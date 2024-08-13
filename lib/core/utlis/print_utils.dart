import 'package:flutter/foundation.dart';

void printD(var message) {
  if (kDebugMode) {
    print(message.toString());
  }
}
