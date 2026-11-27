import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sb_core/sb_core.dart';

part 'customer_account.freezed.dart';
part 'customer_account.g.dart';

@freezed
abstract class CustomerAccount with _$CustomerAccount {
  const factory({
    required String id,
    required String phone,
    required String locale,
    required bool profileComplete,
    String? name,
    String? email,
  }) = _CustomerAccount;

  factory fromJson(Map<String, Object?> json) => _$CustomerAccountFromJson(json);
}

/// Result of a code request: when it expires and when another can be sent.
@freezed
abstract class OtpSent with _$OtpSent {
  const factory({required int expiresIn, required int retryAfter}) = _OtpSent;

  factory fromJson(Map<String, Object?> json) => _$OtpSentFromJson(json);
}

/// A completed customer sign-in.
class CustomerSignIn {
  const new({required this.tokens, required this.account, required this.isNew});

  final AuthTokens tokens;
  final CustomerAccount account;
  final bool isNew;
}
