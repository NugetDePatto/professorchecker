import 'package:flutter/material.dart';

bool dis(BuildContext context) {
  //si es true es tablet, si es false es celular
  //si es mayor a 600 es tablet, si es menor a 600 es celular
  // print(MediaQuery.of(context).size.width);
  return MediaQuery.of(context).size.width >= 600;
}
