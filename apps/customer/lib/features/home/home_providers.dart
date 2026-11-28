import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:smartbarber_customer/app/current_salon.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';
import 'package:smartbarber_customer/features/salon/salon_providers.dart';

part 'home_providers.g.dart';

/// Home data for the current salon and branch.
@riverpod
Future<CustomerHome> home(Ref ref) async {
  final salon = ref.watch(currentSalonProvider);
  if (salon == null) throw StateError('No salon selected');
  return (await ref.watch(customerHomeRepositoryProvider).home(salon.slug, branch: ref.watch(currentBranchProvider))).orThrow;
}

/// The branch the customer books at: their choice, else the salon's first branch.
@riverpod
Future<SalonBranch?> activeBranch(Ref ref) async {
  final salon = ref.watch(currentSalonProvider);
  if (salon == null) return null;
  final branches = await ref.watch(salonBranchesProvider(salon.slug).future);
  if (branches.isEmpty) return null;
  final chosen = ref.watch(currentBranchProvider);
  return branches.where((b) => b.id == chosen).firstOrNull ?? branches.first;
}
