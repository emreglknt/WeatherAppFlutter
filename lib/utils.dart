

import 'package:connectivity_plus/connectivity_plus.dart';

String API_KEY = "9a550c0ac6813fde867aec1e51a6d822";

final List<String> cities = [
  'Ankara', 'Istanbul', 'Izmir', 'Antalya',
  'Tokyo', 'Delhi', 'Shanghai', 'Sao Paulo', 'Mexico City',
  'New York', 'Cairo', 'Mumbai', 'Beijing', 'Dhaka'
];






Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}