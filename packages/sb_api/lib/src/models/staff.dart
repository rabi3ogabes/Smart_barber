import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sb_api/src/models/localized.dart';
import 'package:sb_core/sb_core.dart';

part 'staff.freezed.dart';
part 'staff.g.dart';

Map<String, String> _localized(Object? v) => parseLocalized(v);

@freezed
abstract class StaffUser with _$StaffUser {
  const factory({
    required String id,
    required String name,
    required String locale,
    required bool twoFactorEnabled,
    String? email,
    String? phone,
  }) = _StaffUser;

  factory fromJson(Map<String, Object?> json) => _$StaffUserFromJson(json);
}

@freezed
abstract class SalonSummary with _$SalonSummary {
  const factory({
    required String id,
    required String slug,
    @JsonKey(fromJson: _localized) required Map<String, String> name,
    required String currency,
    required String timezone,
  }) = _SalonSummary;

  factory fromJson(Map<String, Object?> json) => _$SalonSummaryFromJson(json);
}

@freezed
abstract class BranchSummary with _$BranchSummary {
  const factory({
    required String id,
    @JsonKey(fromJson: _localized) required Map<String, String> name,
  }) = _BranchSummary;

  factory fromJson(Map<String, Object?> json) => _$BranchSummaryFromJson(json);
}

/// The signed-in staff member inside the token's salon. Permissions are for display only.
@freezed
abstract class StaffMe with _$StaffMe {
  const factory({
    required StaffUser user,
    required List<String> roles,
    required List<String> permissions,
    required List<BranchSummary> branches,
    required List<String> features,
    SalonSummary? salon,
  }) = _StaffMe;

  const new _();

  factory fromJson(Map<String, Object?> json) => _$StaffMeFromJson(json);

  bool can(String permission) => permissions.contains(permission);
}

/// A salon the staff member may sign in to.
@freezed
abstract class MembershipOption with _$MembershipOption {
  const factory({
    required String salon,
    required String slug,
    @JsonKey(fromJson: _localized) required Map<String, String> name,
  }) = _MembershipOption;

  factory fromJson(Map<String, Object?> json) => _$MembershipOptionFromJson(json);
}

/// What the staff sign-in asks for next.
sealed class StaffLoginStep {
  const new();
}

/// Signed in with tokens bound to [salonId].
final class StaffSignedIn extends StaffLoginStep {
  const new({required this.tokens, required this.salonId});

  final AuthTokens tokens;
  final String salonId;
}

/// Enter a TOTP or recovery code.
final class StaffTwoFactorRequired extends StaffLoginStep {
  const new(this.challengeToken);

  final String challengeToken;
}

/// Pick one of several salons.
final class StaffSalonSelectionRequired extends StaffLoginStep {
  const new({required this.selectionToken, required this.memberships});

  final String selectionToken;
  final List<MembershipOption> memberships;
}
