import 'dart:io';

import 'package:checadordeprofesores/app/data/services/image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/consts/app_keys.dart';
import '../../../core/utlis/cycle_utils.dart';
import '../../../core/utlis/timetable_utils.dart';

class AttendanceService {
  GetStorage attendanceBox = GetStorage(AppKeys.ATTENDANCE);
  GetStorage imageBox = GetStorage(AppKeys.ATTENDANCE_IMAGE);

  setAttendance(
    bool option,
    String professor,
    String keySubject,
    String currentDate,
    String interval,
  ) async {
    String key = '${professor}_${keySubject}_${currentDate}_$interval';

    var attendance = await getAttendance(key);

    attendance['hasAssistance'] = option;
    attendance['time'] = currentTime;

    await attendanceBox.write(key, attendance);

    var reference = FirebaseFirestore.instance
        .collection('ciclos')
        .doc(cycleUtil)
        .collection('asistencias')
        .doc(key);

    Map<String, dynamic> attendanceFirebase = {
      GetStorage(AppKeys.UTILS).read(AppKeys.UTIL_DEVICE_NAME): {
        'hasAssistance': option,
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
      'hasAssistance': null,
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

    return attendance != null ? attendance['hasAssistance'] : null;
  }

  setPicture(
    String professor,
    String keySubject,
    String currentDate,
    String interval,
  ) async {
    String key =
        '${cycleUtil}_${professor}_${keySubject}_${currentDate}_$interval';

    File? fileImage = await ImageService.captureAndCompressImage(key);

    if (fileImage != null) {
      var attendance = await getAttendance(key);

      attendance['image'] = key;

      await attendanceBox.write(key, attendance);

      await imageBox.write(key, {
        'path': fileImage.path,
        'key': key,
      });
    }
  }

  bool hasPicture(
    String professor,
    String keySubject,
    String currentDate,
    String interval,
  ) {
    String key =
        '${cycleUtil}_${professor}_${keySubject}_${currentDate}_$interval';

    var attendance = attendanceBox.read(key);

    return attendance != null ? attendance['image'] != '' : false;
  }
}
