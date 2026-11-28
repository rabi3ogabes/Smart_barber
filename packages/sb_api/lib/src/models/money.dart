import 'package:freezed_annotation/freezed_annotation.dart';

part 'money.freezed.dart';
part 'money.g.dart';

/// Server money: integer minor units + currency, with a ready-formatted string (rule 3).
/// The app never does arithmetic on prices; it displays what the server computed.
@freezed
abstract class Money with _$Money {
  const factory({required int amount, required String currency, required String formatted}) = _Money;

  factory fromJson(Map<String, Object?> json) => _$MoneyFromJson(json);
}
