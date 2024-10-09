import 'package:checadordeprofesores/app/data/services/image_service.dart';
import 'package:checadordeprofesores/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'core/consts/app_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init(AppKeys.UTILS).then((value) async {
    GetStorage(AppKeys.UTILS).writeIfNull(
      AppKeys.UTIL_DEVICE_NAME,
      'Tablet 01',
    );

    GetStorage(AppKeys.UTILS).writeIfNull(
      AppKeys.UTIL_EXTERNAL_DIRECTORY,
      await ImageService.initializeDirectory(),
    );
  });

  await GetStorage.init(AppKeys.TIMETABLE);

  await GetStorage.init(AppKeys.ATTENDANCE);

  await GetStorage.init(AppKeys.ATTENDANCE_IMAGE);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var db = FirebaseFirestore.instance;

  db.waitForPendingWrites();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
