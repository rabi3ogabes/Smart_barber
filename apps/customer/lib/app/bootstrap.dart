import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sb_core/sb_core.dart';
import 'package:smartbarber_customer/app/app.dart';
import 'package:smartbarber_customer/app/providers.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final env = AppEnv.fromDefines();
  final prefs = await AppPreferences.load();

  runApp(
    ProviderScope(
      retry: noProviderRetry,
      overrides: [
        envProvider.overrideWithValue(env),
        preferencesProvider.overrideWithValue(prefs),
      ],
      child: const CustomerApp(),
    ),
  );
}
