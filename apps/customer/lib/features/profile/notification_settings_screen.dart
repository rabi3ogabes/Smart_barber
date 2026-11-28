import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:sb_core/sb_core.dart';
import 'package:sb_ui/sb_ui.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/l10n/generated/app_localizations.dart';

part 'notification_settings_screen.g.dart';

@riverpod
class NotificationSettings extends _$NotificationSettings {
  @override
  Future<NotificationPreferences> build() async => (await ref.watch(customerHomeRepositoryProvider).notificationPreferences()).orThrow;

  /// Shows the change at once; puts it back if the server refuses.
  Future<AppFailure?> save(NotificationPreferences next) async {
    final previous = state.value;
    state = AsyncData(next);
    final result = await ref.read(customerHomeRepositoryProvider).saveNotificationPreferences(next);
    switch (result) {
      case Ok(:final value):
        state = AsyncData(value);
        return null;
      case Err(:final failure):
        if (previous != null) state = AsyncData(previous);
        return failure;
    }
  }
}

class NotificationSettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    Future<void> save(NotificationPreferences p) async {
      final failure = await ref.read(notificationSettingsProvider.notifier).save(p);
      if (failure != null && context.mounted) showFailure(context, failure);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.notificationSettings)),
      body: AsyncView<NotificationPreferences>(
        value: ref.watch(notificationSettingsProvider),
        onRetry: () => ref.invalidate(notificationSettingsProvider),
        builder: (context, p) => ListView(
          padding: const EdgeInsetsDirectional.symmetric(vertical: SbSpace.md),
          children: [
            SwitchListTile(value: p.bookingUpdates, title: Text(l.notifyBookingUpdates), subtitle: Text(l.notifyBookingUpdatesHint), onChanged: (v) => save(p.copyWith(bookingUpdates: v))),
            SwitchListTile(value: p.reminders, title: Text(l.notifyReminders), subtitle: Text(l.notifyRemindersHint), onChanged: (v) => save(p.copyWith(reminders: v))),
            SwitchListTile(value: p.offers, title: Text(l.notifyOffers), subtitle: Text(l.notifyOffersHint), onChanged: (v) => save(p.copyWith(offers: v))),
            Padding(
              padding: const EdgeInsetsDirectional.all(SbSpace.lg),
              child: Text(l.notifySystemHint, style: context.sbText.bodySmall?.copyWith(color: context.sbColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
