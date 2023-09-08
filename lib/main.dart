import 'package:checadordeprofesores/constants/colors.dart';
import 'package:checadordeprofesores/constants/routes.dart';
import 'package:checadordeprofesores/utils/date_utils.dart';
import 'package:checadordeprofesores/utils/secretkey.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await GetStorage.init('asistencias');

  await GetStorage.init('auxiliares');

  var box = GetStorage();

  await box.writeIfNull('codigo', generateCode(fechaActual));

  await box.writeIfNull('ciclo', '2023 - 2 Verano');

  // await GetStorage('auxiliares').erase();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var db = FirebaseFirestore.instance;

  await db.waitForPendingWrites();

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
      initialRoute: '/prueba',
      routes: routes,
    );
  }
}
