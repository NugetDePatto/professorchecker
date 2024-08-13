import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'core/consts/getstorage_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// - latestProfessorUpdate
  await GetStorage.init(GetStorageKey.utils);
  await GetStorage.init(GetStorageKey.timetable);

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
