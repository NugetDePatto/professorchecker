import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../../core/utlis/dispose_util.dart';
import '../../../widgets/appbar_widget.dart';
import '../controllers/recorrido_controller.dart';
import 'blocks_buttons_view.dart';
import 'day_adjuster_view.dart';
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
            onPressed: controller.resetAll,
            icon: Icon(
              Icons.restore,
              color: ColorsTheme.iconColor,
              size: getSize(30),
            ),
          ),
          SizedBox(width: getSize(10)),
        ],
      ),
      backgroundColor: ColorsTheme.backgroundColor,
      body: Column(
        children: [
          Wrap(
            children: [
              const DayAdjusterView(),
              SizedBox(height: getSize(10)),
              const IntervalAdjusterView(),
            ],
          ),
          SizedBox(height: getSize(10)),
          const BlocksButtonsView(),
          SizedBox(height: getSize(10)),
          Obx(
            () => Expanded(
              child: controller.timetableIsReady.isTrue
                  ? controller.getBlock.isNotEmpty
                      ? Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(getSize(20)),
                            ),
                          ),
                          child: ListView(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorsTheme.subjectCardColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(getSize(20)),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    for (var classroom
                                        in controller.getBlock.entries)
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
                      : Center(
                          child: Text(
                            'No hay clases en este horario',
                            style: TextStyle(
                              color: ColorsTheme.textColor,
                              fontSize: getSize(16),
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
