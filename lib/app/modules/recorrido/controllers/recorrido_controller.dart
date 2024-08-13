import 'package:get/get.dart';
import '../../../../core/utlis/print_utils.dart';
import '../../../../core/utlis/snackbar_util.dart';
import '../../../data/services/timetable_service.dart';

class RecorridoController extends GetxController {
  TimetableService timetableService = TimetableService();

  RxList timetable = [].obs;

  RxBool timetableIsReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCycleTimetable();
  }

  void getCycleTimetable() async {
    timetableService.updateProfessorsTimetable().then((value) async {
      if (value == 'No hay cambios en el horario') {
        await Future.delayed(const Duration(milliseconds: 500), () {});
      }

      timetable.value = timetableService.getTimetable;
      timetableIsReady.value = true;

      snackbarUtil(value);
    });
  }

  test() {
    printD('test');
  }
}
