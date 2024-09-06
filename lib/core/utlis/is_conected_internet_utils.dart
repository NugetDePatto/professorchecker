import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

Future<bool> isConnectedToInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult != ConnectivityResult.none) {
    try {
      final response =
          await http.get(Uri.parse('https://www.google.com')).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Add a return statement here
          return http.Response('Error', 408);
        },
      );

      if (response.statusCode == 200) {
        print('Conectado a internet');
        return true;
      }
    } catch (e) {
      print('Error de conexión o tiempo de espera agotado: $e');
      return false;
    }
  }
  print('No hay conexión a internet');
  return false;
}
