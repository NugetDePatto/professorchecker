import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateCode(String secretKey) {
  // Obtener el tiempo actual en segundos
  int time = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  // Concatenar la llave secreta y el tiempo actual
  String combined = secretKey + time.toString();

  // Calcular el hash criptográfico (SHA-256) del valor combinado
  List<int> bytes = utf8.encode(combined);
  Digest hash = sha256.convert(bytes);

  // Tomar solo los primeros 4 dígitos del valor hash y convertirlos a decimal
  int decimal = int.parse(hash.toString().substring(0, 8), radix: 16);

  // Asegurarse de que el código de acceso tenga exactamente 4 dígitos
  String code = decimal.toString().padLeft(8, '0');

  return code;
}
