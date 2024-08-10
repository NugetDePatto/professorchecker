import 'package:checadordeprofesores/get_test/core/utlis/datetime_utils.dart';
import 'package:get/get.dart';

class HourAdjusterController extends GetxController {
  RxString currentHourRx = currentHour.obs;

  @override
  void onInit() {
    super.onInit();
    setCurrentHour();
  }

  void setHorarioActual() {
    currentHourRx.value =
        '${DateTime.now().hour}:00 - ${DateTime.now().hour + 1}:00';
  }

  void incrementHour() {
    final hour = (int.parse(currentHourRx.value.split(':')[0]) + 1) % 24;
    currentHourRx.value = '$hour:00 - ${hour + 1}:00';
  }

  void decrementHour() {
    final hour = (int.parse(currentHourRx.value.split(':')[0]) - 1) % 24;
    currentHourRx.value = '$hour:00 - ${hour + 1}:00';
  }
}
