import 'package:checadordeprofesores/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'constants/colors.dart';
import 'constants/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await GetStorage.init('imagenes');

  await GetStorage.init('asistencias');

  await GetStorage.init('auxiliares');

  GetStorage box = GetStorage();

  await box.writeIfNull('codigo', 'dispositivo_Test 01');

  await box.writeIfNull('ciclo', '2023 - 2 Verano');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var db = FirebaseFirestore.instance;

  db.waitForPendingWrites();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demos',
      theme: myTheme,
      initialRoute: '/',
      routes: routes,
    );
  }
}