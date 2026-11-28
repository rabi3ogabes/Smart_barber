import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sb_api/sb_api.dart';
import 'package:smartbarber_customer/app/providers.dart';

part 'current_salon.g.dart';

/// The salon the app is open on, remembered across launches (Phase 5: "remember the last salon").
/// The chosen branch is remembered per salon. Only ids and display data are kept here.
@Riverpod(keepAlive: true)
class CurrentSalon extends _$CurrentSalon {
  static const _key = 'sb.salon';

  @override
  SalonCard? build() {
    final raw = ref.read(preferencesProvider).getString(_key);
    if (raw == null) return null;
    try {
      return SalonCard.fromJson((jsonDecode(raw) as Map).cast<String, Object?>());
    } on Object {
      return null;
    }
  }

  Future<void> select(SalonCard salon) async {
    await ref.read(preferencesProvider).setString(_key, jsonEncode(salon.toJson()));
    state = salon;
  }

  Future<void> clear() async {
    await ref.read(preferencesProvider).remove(_key);
    state = null;
  }
}

/// The branch chosen for the current salon (null = the server's default branch).
@Riverpod(keepAlive: true)
class CurrentBranch extends _$CurrentBranch {
  String _key(String salonId) => 'sb.branch.$salonId';

  @override
  String? build() {
    final salon = ref.watch(currentSalonProvider);
    return salon == null ? null : ref.read(preferencesProvider).getString(_key(salon.id));
  }

  Future<void> select(String branchId) async {
    final salon = ref.read(currentSalonProvider);
    if (salon == null) return;
    await ref.read(preferencesProvider).setString(_key(salon.id), branchId);
    state = branchId;
  }
}
