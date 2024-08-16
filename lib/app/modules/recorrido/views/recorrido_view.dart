import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../widgets/appbar_widget.dart';
import '../controllers/recorrido_controller.dart';
import 'blocks_buttons_view.dart';
import 'interval_adjuster_view.dart';
import '../widgets/subject_card/subject_card_widget.dart';

class RecorridoView extends GetView<RecorridoController> {
  const RecorridoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Lista de Asistencia',
        actions: [
          IconButton(
            onPressed: controller.setCurrentInterval,
            icon: const Icon(
              Icons.restore,
              color: ColorsTheme.iconColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: ColorsTheme.backgroundColor,
      body: Column(
        children: [
          const IntervalAdjusterView(),
          const SizedBox(height: 10),
          const BlocksButtonsView(),
          const SizedBox(height: 10),
          Obx(
            () => Expanded(
              child: controller.timetableIsReady.isTrue
                  ? controller.getBlock.isNotEmpty
                      ? Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: ListView(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 15,
                                ),
                                decoration: const BoxDecoration(
                                  color: ColorsTheme.subjectCardColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    for (var classroom
                                        in controller.getBlock.entries)
                                      // Text(
                                      //   classroom.key,
                                      //   style: const TextStyle(
                                      //     color: ColorsTheme.textColor,
                                      //     fontSize: 20,
                                      //   ),
                                      // ),
                                      for (var subject
                                          in classroom.value.entries)
                                        SubjectCardWidget(
                                          classroom: classroom.key,
                                          subject: subject,
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Center(
                          child: Text(
                            'No hay clases en este horario',
                            style: TextStyle(
                              color: ColorsTheme.textColor,
                              fontSize: 16,
                            ),
                          ),
                        )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: controller.test,
              child: const Icon(Icons.android_rounded),
            )
          : null,
    );
  }
}
