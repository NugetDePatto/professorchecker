import 'package:checadordeprofesores/app/modules/images/views/up_images_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../../core/utlis/dispose_util.dart';
import '../../../widgets/appbar_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/button_home_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsTheme.backgroundColor,
      appBar: const AppBarWidget(title: 'Asistencia UAT'),
      body: Padding(
        padding: EdgeInsets.all(getSize(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorsTheme.homeButtonColor,
                borderRadius: BorderRadius.circular(getSize(20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ButtonHomeWidget(
                    text: 'Lista de Asistencia',
                    icon: Icons.checklist_outlined,
                    onPressed: controller.attendanceButton,
                  ),
                  const ButtonHomeWidget(
                    text: 'Subir Imagenes',
                    icon: Icons.photo_camera_back_outlined,
                    onPressed: upImagesDialog,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
