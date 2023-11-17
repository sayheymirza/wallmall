import 'package:connectivity_plus/connectivity_plus.dart';

class _Connectivity {
  final Connectivity self = Connectivity();

  Future<bool> get connected async {
    var result = await self.checkConnectivity();

    return result != ConnectivityResult.none;
  }
}

// ignore: library_private_types_in_public_api
_Connectivity connectivity = _Connectivity();
