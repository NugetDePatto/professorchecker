import 'package:get/get.dart';

import '../../../../core/utlis/snackbar_util.dart';
import '../../../../core/utlis/timetable_utils.dart';
// import '../../../data/services/attendance_service.dart';
import '../../../data/services/timetable_service.dart';

class RecorridoController extends GetxController {
  TimetableService timetableService = TimetableService();

  RxBool timetableIsReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    setCurrentInterval();
    getCycleTimetable();
  }

  void getCycleTimetable() async {
    timetableService.updateProfessorsTimetable().then((value) async {
      if (value == 'No hay cambios en el horario') {
        await Future.delayed(const Duration(milliseconds: 500), () {});
      } else {
        snackbarUtil(value);
      }

      timetableIsReady.value = true;
    });
  }

  Map get getBlock => timetableService.getBlock(
      currentInterval.value, blockSelected.value, currentDayIndex.value);

  // interval

  RxString currentInterval = ''.obs;

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

  //block
  var blockSelected = 'A'.obs;

  void selectBlock(String block) {
    blockSelected.value = block;
  }

  bool isSelected(String block) {
    return blockSelected.value == block;
  }

  //day

  RxString currentDay = dayOfWeekString(dayOfWeek).obs;

  RxInt currentDayIndex = dayOfWeek.obs;

  void incrementDay() {
    currentDayIndex.value = (currentDayIndex.value + 1) % 7;
    currentDay.value = dayOfWeekString(currentDayIndex.value);
  }

  void decrementDay() {
    currentDayIndex.value = (currentDayIndex.value - 1) % 7;
    currentDay.value = dayOfWeekString(currentDayIndex.value);
  }

  void setCurrentDay() {
    currentDay.value = dayOfWeekString(dayOfWeek);
    currentDayIndex.value = dayOfWeek;
  }

  int get getCurrentDay => currentDayIndex.value;

  void resetAll() {
    setCurrentInterval();
    setCurrentDay();
  }

  test() {}
}
