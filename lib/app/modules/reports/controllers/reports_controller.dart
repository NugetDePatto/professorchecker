import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsController extends GetxController {
  TextEditingController textEditingController = TextEditingController();

  setTextEditingController(String value) {
    if (textEditingController.text.isEmpty) {
      textEditingController.text = value;
    } else {
      textEditingController.text = '${textEditingController.text}, $value';
    }
  }
}
