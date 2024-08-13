import 'package:connectivity/connectivity.dart';

Future<bool> isConectedInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}
