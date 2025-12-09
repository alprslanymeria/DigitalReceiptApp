import 'package:connectivity_plus/connectivity_plus.dart';

/// Network info interface - follows Dependency Inversion Principle
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
