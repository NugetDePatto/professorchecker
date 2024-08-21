import 'package:get/get.dart';

import '../../../../../core/utlis/timetable_utils.dart';
import '../../../../data/services/attendance_service.dart';

class SubjectCardController extends GetxController {
  var close = false.obs;
  var check = false.obs;

  var isFirstTime = true;

  getAssistance(var subject, int day) {
    bool? hasAssistance = AttendanceService().hasAttendance(
      subject['titular'],
      subject['clave'],
      currentDate,
      subject['horario'][day],
    );

    if (hasAssistance != null) {
      if (hasAssistance) {
        check.value = true;
        close.value = false;
      } else {
        check.value = false;
        close.value = true;
      }
    }
  }

  setAssistance(bool option, var subject, int day) async {
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

    if (option) {
      check.value = true;
      close.value = false;
    } else {
      check.value = false;
      close.value = true;
    }
  }
}
