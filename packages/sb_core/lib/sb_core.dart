/// Networking, auth tokens, errors, environment, storage and connectivity shared by
/// the Smart Barber apps (ADR-006). No business rules live here (rule 1).
library;

export 'src/auth/auth_tokens.dart';
export 'src/auth/token_store.dart';
export 'src/connectivity/connectivity_service.dart';
export 'src/env/app_env.dart';
export 'src/failures/api_error_code.dart';
export 'src/failures/app_failure.dart';
export 'src/failures/result.dart';
export 'src/logging/app_logger.dart';
export 'src/network/api_client.dart';
export 'src/network/auth_interceptor.dart';
export 'src/network/idempotency.dart';
export 'src/network/locale_interceptor.dart';
export 'src/network/retry_interceptor.dart';
export 'src/storage/app_preferences.dart';
