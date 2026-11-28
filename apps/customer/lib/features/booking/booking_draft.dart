import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:smartbarber_customer/app/current_salon.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';

part 'booking_draft.g.dart';

enum BookingStep { services, barber, time, summary, done }

/// The stepper's working state: ids the customer picked. Prices, durations and free times are
/// always fetched from the server for this selection (rule 1).
class BookingDraftState {
  const new({
    this.step = BookingStep.services,
    this.branch,
    this.services = const {},
    this.addons = const {},
    this.bundles = const {},
    this.barber,
    this.date,
    this.slot,
    this.idempotencyKey,
    this.notes = '',
    this.created,
    this.alternatives = const [],
  });

  final BookingStep step;
  final String? branch;
  final Set<String> services;
  final Set<String> addons;
  final Set<String> bundles;

  /// Barber public id; null = "any available".
  final String? barber;

  /// Branch-local date `YYYY-MM-DD`.
  final String? date;
  final Slot? slot;

  /// Created once when the customer first taps Confirm; reused for every retry of that tap (rule 6).
  final String? idempotencyKey;
  final String notes;
  final CustomerBooking? created;

  /// Start times the server suggested after a 409.
  final List<DateTime> alternatives;

  bool get hasSelection => services.isNotEmpty || bundles.isNotEmpty;

  BookingSelection? get selection => branch == null
      ? null
      : BookingSelection(branch: branch!, services: services.toList(), addons: addons.toList(), bundles: bundles.toList(), barber: barber);

  BookingDraftState copyWith({
    BookingStep? step,
    String? branch,
    Set<String>? services,
    Set<String>? addons,
    Set<String>? bundles,
    String? Function()? barber,
    String? Function()? date,
    Slot? Function()? slot,
    String? Function()? idempotencyKey,
    String? notes,
    CustomerBooking? Function()? created,
    List<DateTime>? alternatives,
  }) => BookingDraftState(
    step: step ?? this.step,
    branch: branch ?? this.branch,
    services: services ?? this.services,
    addons: addons ?? this.addons,
    bundles: bundles ?? this.bundles,
    barber: barber != null ? barber() : this.barber,
    date: date != null ? date() : this.date,
    slot: slot != null ? slot() : this.slot,
    idempotencyKey: idempotencyKey != null ? idempotencyKey() : this.idempotencyKey,
    notes: notes ?? this.notes,
    created: created != null ? created() : this.created,
    alternatives: alternatives ?? this.alternatives,
  );
}

/// What happened when the customer tapped Confirm.
sealed class ConfirmOutcome {
  const new();
}

final class Confirmed extends ConfirmOutcome {
  const new(this.booking);

  final CustomerBooking booking;
}

/// 409 BOOKING_SLOT_TAKEN: the time went to someone else; free times were refreshed.
final class SlotTaken extends ConfirmOutcome {
  const new();
}

final class ConfirmFailed extends ConfirmOutcome {
  const new(this.failure);

  final AppFailure failure;
}

@Riverpod(keepAlive: true)
class BookingDraft extends _$BookingDraft {
  @override
  BookingDraftState build() {
    ref.listen(currentSalonProvider, (prev, next) {
      if (prev?.id != next?.id) state = const BookingDraftState();
    });
    return const BookingDraftState();
  }

  void reset() => state = BookingDraftState(branch: state.branch);

  void setBranch(String branch) {
    if (branch == state.branch) return;
    state = BookingDraftState(branch: branch);
  }

  /// Pre-fills from "Book again" (same services, add-ons and barber at that branch).
  void prefill(BookAgain again) => state = BookingDraftState(
    branch: again.branch,
    services: again.services.toSet(),
    addons: again.addons.toSet(),
    bundles: again.bundles.toSet(),
    barber: again.barber?.id,
    step: BookingStep.barber,
  );

  /// Starts with one service selected (popular service tap).
  void startWith(String branch, String service) => state = BookingDraftState(branch: branch, services: {service});

  void toggleService(CatalogService service) {
    final services = {...state.services};
    final addons = {...state.addons};
    if (!services.remove(service.id)) {
      services.add(service.id);
    } else {
      addons.removeAll(service.addons.map((a) => a.id));
    }
    state = state.copyWith(services: services, addons: addons, slot: () => null, idempotencyKey: () => null);
  }

  void toggleAddon(String addon) {
    final addons = {...state.addons};
    if (!addons.remove(addon)) addons.add(addon);
    state = state.copyWith(addons: addons, slot: () => null, idempotencyKey: () => null);
  }

  void toggleBundle(String bundle) {
    final bundles = {...state.bundles};
    if (!bundles.remove(bundle)) bundles.add(bundle);
    state = state.copyWith(bundles: bundles, slot: () => null, idempotencyKey: () => null);
  }

  void chooseBarber(String? barber) => state = state.copyWith(barber: () => barber, slot: () => null, idempotencyKey: () => null);

  void chooseDate(String date) => state = state.copyWith(date: () => date, slot: () => null, idempotencyKey: () => null);

  void chooseSlot(Slot slot) => state = state.copyWith(slot: () => slot, idempotencyKey: () => null, alternatives: const []);

  void setNotes(String notes) => state = state.copyWith(notes: notes);

  void goTo(BookingStep step) => state = state.copyWith(step: step);

  Future<ConfirmOutcome> confirm() async {
    final selection = state.selection;
    final slot = state.slot;
    if (selection == null || slot == null) return const ConfirmFailed(UnknownFailure('incomplete'));
    final key = state.idempotencyKey ?? Idempotency.newKey();
    state = state.copyWith(idempotencyKey: () => key);

    final result = await ref
        .read(bookingRepositoryProvider)
        .create(selection, slot.startsAt, idempotencyKey: key, notes: state.notes.trim().isEmpty ? null : state.notes.trim());
    switch (result) {
      case Ok(:final value):
        state = state.copyWith(step: BookingStep.done, created: () => value);
        return Confirmed(value);
      case Err(failure: final ApiFailure f) when f.code == 'BOOKING_SLOT_TAKEN':
        final alternatives = (f.data['alternatives'] as List<dynamic>? ?? const []).whereType<String>().map((s) => DateTime.parse(s).toUtc()).toList();
        state = state.copyWith(step: BookingStep.time, slot: () => null, idempotencyKey: () => null, alternatives: alternatives);
        ref.invalidate(slotsProvider);
        return const SlotTaken();
      case Err(:final failure):
        return ConfirmFailed(failure);
    }
  }
}

@riverpod
Future<ServiceMenu> branchMenu(Ref ref, String branch) async => (await ref.watch(catalogRepositoryProvider).menu(branch)).orThrow;

@riverpod
Future<List<BarberProfile>> branchBarbers(Ref ref, String branch) async => (await ref.watch(catalogRepositoryProvider).barbers(branch)).orThrow;

/// Free times for the draft's selection on its date.
@riverpod
Future<SlotDay> slots(Ref ref, BookingSelection selection, String date) async =>
    (await ref.watch(catalogRepositoryProvider).slots(selection, date)).orThrow;

/// The server quote shown on the summary step.
@riverpod
Future<Quote> quote(Ref ref, BookingSelection selection) async => (await ref.watch(bookingRepositoryProvider).quote(selection)).orThrow;
