import 'package:checadordeprofesores/constants/colors.dart';
import 'package:checadordeprofesores/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/horario_model.dart';
import 'models/salon_model.dart';

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter<Horario>(HorarioAdapter());
  Hive.registerAdapter<Salon>(SalonAdapter());

  await Hive.openBox<Salon>('salones').then((value) {
    // SalonController().addAll(salonesMapa);
  });

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
