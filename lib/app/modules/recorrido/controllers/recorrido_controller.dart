import 'package:get/get.dart';

import '../../../../core/utlis/print_utils.dart';
import '../../../../core/utlis/snackbar_util.dart';
import '../../../../core/utlis/timetable_utils.dart';
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

  Map get getBlock =>
      timetableService.getBlock(currentInterval.value, blockSelected.value);

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

  //subject
  hasAssistance() {
    return false;
  }

  setAssistance(bool option, var info) {
    String professor = info['titular'];
    String keySubject = info['clave'];
    String interval = info['horario'][dayOfWeek];

    String key = '${professor}_${keySubject}_${date}_$interval';

    printD('key: $key');
    printD('aula: ${info['aula']}');
    update();
  }

  test() {}
}
