import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Online / offline signal for the offline banner (flutter.md, Offline).
class ConnectivityService {
  new([Connectivity? connectivity]) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Current state.
  Future<bool> isOnline() async => _online(await _connectivity.checkConnectivity());

  /// Changes over time.
  Stream<bool> watch() => _connectivity.onConnectivityChanged.map(_online).distinct();

  static bool _online(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}
