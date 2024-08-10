import 'package:checadordeprofesores/get_test/app/modules/recorrido/widgets/hour_adjuster/hour_adjuster_view.dart';
import 'package:checadordeprofesores/get_test/app/widgets/appbar_widget.dart';
import 'package:checadordeprofesores/get_test/core/theme/colors_theme.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/recorrido_controller.dart';

class RecorridoView extends GetView<RecorridoController> {
  const RecorridoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(title: 'Recorrido Actual'),
      backgroundColor: ColorsTheme.backgroundColor,
      body: Column(
        children: [
          HourAdjusterView(),
        ],
      ),
    );
  }
}
