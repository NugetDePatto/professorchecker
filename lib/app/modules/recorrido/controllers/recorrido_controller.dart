import 'package:get/get.dart';
import '../../../../core/utlis/print_utils.dart';
import '../../../../core/utlis/snackbar_util.dart';
import '../../../data/services/timetable_service.dart';
import '../widgets/blocks_buttons/blocks_buttons_controller.dart';
import '../widgets/interval_adjuster/interval_adjuster_controller.dart';

class RecorridoController extends GetxController {
  TimetableService timetableService = TimetableService();

  RxBool timetableIsReady = false.obs;

  get interval => Get.find<IntervalAdjusterController>().currentInterval.value;

  get block => Get.find<BlocksButtonsController>().blockSelected.value;

  @override
  void onInit() {
    super.onInit();
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

  Map get getBlock => timetableService.getBlock(interval, block);

  test() {
    getBlock.forEach((key, value) {
      printD(key);
      // printD(value);
    });
  }
}
