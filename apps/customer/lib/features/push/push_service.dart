import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Push notifications behind an interface (rule 9): the app only needs a token to register and the
/// deep link of a tapped notification.
abstract interface class PushService {
  /// Initialises the provider, asks for permission and requests a token. False when push is not
  /// configured here or the user said no.
  Future<bool> start();

  /// The device token, each time the provider issues one (first registration and refreshes).
  Stream<String> get tokens;

  /// Deep links (`smartbarber://booking/{id}`) of notifications the user tapped while the app ran.
  Stream<String> get openedLinks;

  /// The deep link of the notification that launched the app, if any.
  Future<String?> initialLink();
}

/// Used when no Firebase project is configured for this build (e.g. local dev and tests).
class DisabledPushService implements PushService {
  const new();

  @override
  Future<bool> start() async => false;

  @override
  Stream<String> get tokens => const Stream.empty();

  @override
  Stream<String> get openedLinks => const Stream.empty();

  @override
  Future<String?> initialLink() async => null;
}

/// Firebase Cloud Messaging. Configured with compile-time defines, so no google-services file is
/// committed: FIREBASE_API_KEY, FIREBASE_APP_ID, FIREBASE_SENDER_ID, FIREBASE_PROJECT_ID.
class FirebasePushService implements PushService {
  const new(this.options);

  final FirebaseOptions options;

  /// Null when the build carries no Firebase defines.
  static FirebasePushService? fromDefines() {
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    const senderId = String.fromEnvironment('FIREBASE_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
    if (apiKey.isEmpty || appId.isEmpty || senderId.isEmpty || projectId.isEmpty) return null;
    return const FirebasePushService(FirebaseOptions(apiKey: apiKey, appId: appId, messagingSenderId: senderId, projectId: projectId));
  }

  static String? _link(RemoteMessage? message) {
    final link = message?.data['link'];
    return link is String && link.isNotEmpty ? link : null;
  }

  @override
  Future<bool> start() async {
    try {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp(options: options);
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return false;
      await FirebaseMessaging.instance.register();
      return true;
    } on Object catch (e) {
      debugPrint('Push unavailable: $e');
      return false;
    }
  }

  @override
  Stream<String> get tokens => FirebaseMessaging.instance.onRegistered;

  @override
  Stream<String> get openedLinks => FirebaseMessaging.onMessageOpenedApp.map(_link).where((l) => l != null).cast<String>();

  @override
  Future<String?> initialLink() async => _link(await FirebaseMessaging.instance.getInitialMessage());
}
