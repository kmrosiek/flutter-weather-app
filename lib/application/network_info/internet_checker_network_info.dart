import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weatherapp/domain/core/network_info.dart';

@LazySingleton(as: INetworkInfo)
class InternetCheckerNetworkInfo implements INetworkInfo {
  @override
  Future<bool> get isConnected {
    if (kIsWeb) {
      return Future.value(true);
    }

    return InternetConnectionChecker().hasConnection;
  }
}
