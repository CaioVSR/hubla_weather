import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Service that checks real internet reachability.
///
/// Wraps [InternetConnection] from `internet_connection_checker_plus`
/// to provide a simple interface for connectivity checks.
class HublaConnectivityService {
  HublaConnectivityService({InternetConnection? internetConnection}) : _internetConnection = internetConnection ?? InternetConnection();

  final InternetConnection _internetConnection;

  /// Returns `true` if the device currently has internet access.
  Future<bool> hasInternetConnection() => _internetConnection.hasInternetAccess;

  /// Emits `true` when connectivity is restored and `false` when lost.
  Stream<InternetStatus> get onStatusChanged => _internetConnection.onStatusChange;
}
