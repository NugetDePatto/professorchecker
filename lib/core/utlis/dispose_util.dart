import 'package:get/get.dart';

double getSize(double size, {double? sizeTablet}) {
  if (Get.width > 600) {
    return sizeTablet ?? size + 10;
  } else {
    return size;
  }
}
