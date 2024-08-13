import 'package:get/get.dart';

class BlocksButtonsController extends GetxController {
  var blockSelected = 'A'.obs;

  void selectBlock(String block) {
    blockSelected.value = block;
  }

  bool isSelected(String block) {
    return blockSelected.value == block;
  }
}
