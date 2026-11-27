/// Typed models and repositories for the Smart Barber API (/api/v1). Values such as prices,
/// slots and balances always come from the server; nothing here computes business rules.
library;

export 'src/envelope.dart';
export 'src/models/app_config.dart';
export 'src/models/customer_account.dart';
export 'src/models/localized.dart';
export 'src/models/staff.dart';
export 'src/repositories/customer_auth_repository.dart';
export 'src/repositories/devices_repository.dart';
export 'src/repositories/meta_repository.dart';
export 'src/repositories/staff_auth_repository.dart';
