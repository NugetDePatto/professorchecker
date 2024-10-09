import 'package:checadordeprofesores/app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../../../../../core/utlis/snackbar_util.dart';
import '../../../../../core/utlis/timetable_utils.dart';
import '../../../../data/services/attendance_service.dart';
import '../../controllers/recorrido_controller.dart';
import '../../views/more_info_dialog.dart';

class SubjectCardController extends GetxController {
  final dynamic subject;

  SubjectCardController(this.subject);

  final recorridoController = Get.find<RecorridoController>();

  final attendanceService = AttendanceService();

  //un rxbool que pueda ser nulo
  var check = RxnBool(null);

  var hasPicture = false.obs;

  bool? getAttendance(bool type) {
    int day = recorridoController.currentDayIndex.value;

    check.value = AttendanceService().hasAttendance(
      subject['titular'],
      subject['clave'],
      currentDate,
      subject['horario'][day],
    );

    if (check.value != null) {
      return check.value == type;
    }
    return null;
  }

  Future<void> setAttendance(bool option) async {
    int day = recorridoController.currentDayIndex.value;
    String professor = subject['titular'];
    String keySubject = subject['clave'];
    String interval = subject['horario'][day];

    await AttendanceService().setAttendance(
      option,
      professor,
      keySubject,
      currentDate,
      interval,
    );

    check.value = option;
  }

  moreInfoButton() {
    moreInfoDialog(subject, recorridoController.getCurrentDay);
  }

  takeAPictureButton() {
    if (getAttendance(true) != null) {
      attendanceService
          .setPicture(
        subject['titular'],
        subject['clave'],
        currentDate,
        subject['horario'][recorridoController.currentDayIndex.value],
      )
          .then(
        (value) {
          hasPicture.value = true;
        },
      );
    } else {
      snackbarUtil('No puedes tomar una foto si no has marcado asistencia');
    }
  }

  bool getHasPicture() {
    hasPicture.value = attendanceService.hasPicture(
      subject['titular'],
      subject['clave'],
      currentDate,
      subject['horario'][recorridoController.currentDayIndex.value],
    );

    return hasPicture.value;
  }

  reportButton() {
    bool type = true;

    if (type) {
      Get.toNamed(
        Routes.PROFESSOR_REPORTS,
        arguments: {
          'professor': subject['titular'],
          'subject': subject['clave'],
          'date': currentDate,
          'interval': subject['horario']
              [recorridoController.currentDayIndex.value],
        },
      );
    }
  }
}
