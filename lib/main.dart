import 'package:checadordeprofesores/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'core/consts/app_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init(AppKeys.utils).then((value) {
    GetStorage(AppKeys.utils).writeIfNull(
      AppKeys.utilsDeviceName,
      'Tablet 01',
    );
  });

  await GetStorage.init(AppKeys.timetable);

  await GetStorage.init(AppKeys.attendance);

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
