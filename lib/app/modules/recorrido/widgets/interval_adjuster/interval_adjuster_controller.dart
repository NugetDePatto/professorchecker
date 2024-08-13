import 'package:get/get.dart';

class IntervalAdjusterController extends GetxController {
  RxString currentInterval = ''.obs;

  @override
  void onInit() {
    super.onInit();
    setCurrentInterval();
  }

  void setCurrentInterval() {
    currentInterval.value =
        '${DateTime.now().hour}:00 - ${DateTime.now().hour + 1}:00';
  }

  void incrementHour() {
    final hour = (int.parse(currentInterval.value.split(':')[0]) + 1) % 24;
    currentInterval.value = '$hour:00 - ${hour + 1}:00';
  }

  void decrementHour() {
    final hour = (int.parse(currentInterval.value.split(':')[0]) - 1) % 24;
    currentInterval.value = '$hour:00 - ${hour + 1}:00';
  }
}
