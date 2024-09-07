import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/consts/app_keys.dart';
import '../../../core/utlis/cycle_utils.dart';
import '../../../core/utlis/timetable_utils.dart';

class AttendanceService {
  GetStorage attendanceBox = GetStorage(AppKeys.attendance);

  setAttendance(
    bool option,
    String professor,
    String keySubject,
    String currentDate,
    String interval,
  ) async {
    String key = '${professor}_${keySubject}_${currentDate}_$interval';

    var attendance = await getAttendance(key);

    attendance['hasAttendance'] = option;
    attendance['time'] = currentTime;

    await attendanceBox.write(key, attendance);

    var reference = FirebaseFirestore.instance
        .collection('ciclos')
        .doc(cycleUtil)
        .collection('asistencias')
        .doc(key);

    Map<String, dynamic> attendanceFirebase = {
      GetStorage(AppKeys.utils).read(AppKeys.utilsDeviceName): {
        'hasAttendance': option,
        'time': currentTime,
        'image': attendance['image'],
        'timeServer': FieldValue.serverTimestamp(),
      },
      'professor': professor,
      'keySubject': keySubject,
      'currentDate': currentDate,
      'interval': interval,
    };

    reference.set({...attendanceFirebase}, SetOptions(merge: true));
  }

  getAttendance(String key) async {
    Map<String, dynamic> attendance = {
      'hasAttendance': null,
      'time': '',
      'image': ''
    };

    await attendanceBox.writeIfNull(
      key,
      attendance,
    );

    return attendanceBox.read(key);
  }

  bool? hasAttendance(
    String professor,
    String keySubject,
    String currentDate,
    String interval,
  ) {
    var attendance = attendanceBox.read(
      '${professor}_${keySubject}_${currentDate}_$interval',
    );

    return attendance != null ? attendance['hasAttendance'] : null;
  }
}
