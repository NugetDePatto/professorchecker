import 'package:checadordeprofesores/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'core/consts/getstorage_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// - lastUpdateCache
  await GetStorage.init(GetStorageKey.utils);

  await GetStorage.init(GetStorageKey.timetable);

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
