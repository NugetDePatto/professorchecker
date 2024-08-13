import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../widgets/appbar_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/button_home_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsTheme.backgroundColor,
      appBar: const AppBarWidget(title: 'ASIESTENCIA UAT'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonHomeWidget(
            text: 'Recorrido Actual',
            icon: Icons.directions_walk,
            onPressed: () {
              Get.toNamed('/recorrido');
            },
          ),
          ButtonHomeWidget(
            text: 'Lista de Asistencias',
            icon: Icons.checklist,
            onPressed: () {},
          ),
          ButtonHomeWidget(
            text: 'Profesores y Materias',
            icon: Icons.school,
            onPressed: () {},
          ),
          ButtonHomeWidget(
            text: 'Subir Imagenes',
            icon: Icons.image,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
