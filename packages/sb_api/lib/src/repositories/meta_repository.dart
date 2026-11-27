import 'package:dio/dio.dart';
import 'package:sb_api/src/envelope.dart';
import 'package:sb_api/src/models/app_config.dart';
import 'package:sb_core/sb_core.dart';

class MetaRepository {
  const new(this._dio);

  final Dio _dio;

  Future<Result<AppConfig>> appConfig() => Result.guard(() async {
    final res = await _dio.get<dynamic>('/meta/app-config', options: noAuth);
    return AppConfig.fromJson(envelopeData(res));
  });
}
