import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:smartbarber_customer/app/providers.dart';
import 'package:smartbarber_customer/features/common/async_view.dart';

part 'salon_providers.g.dart';

/// Salons this account has booked with.
@riverpod
Future<List<SalonCard>> mySalons(Ref ref) async => (await ref.watch(salonRepositoryProvider).mine()).orThrow;

/// Active branches of a salon with today's hours.
@riverpod
Future<List<SalonBranch>> salonBranches(Ref ref, String salon) async => (await ref.watch(salonRepositoryProvider).branches(salon)).orThrow;
