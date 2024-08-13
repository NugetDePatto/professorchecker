import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../widgets/appbar_widget.dart';
import '../controllers/recorrido_controller.dart';
import '../widgets/blocks_buttons/blocks_buttons_view.dart';
import '../widgets/interval_adjuster/interval_adjuster_controller.dart';
import '../widgets/interval_adjuster/interval_adjuster_view.dart';
import '../widgets/subject_card/subject_car_widget.dart';

class RecorridoView extends GetView<RecorridoController> {
  const RecorridoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var intervalController = Get.put(IntervalAdjusterController());
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Recorrido Actual',
        actions: [
          IconButton(
            onPressed: intervalController.setCurrentInterval,
            icon: const Icon(
              Icons.restore,
              color: ColorsTheme.iconButtonColor,
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
          const BlocksButtonsView(),
          Obx(
            () => Expanded(
              child: controller.timetableIsReady.isTrue
                  ? ListView(
                      children: [
                        for (var classroom in controller.getBlock.entries)
                          for (var subject in classroom.value.entries)
                            SubjectCarWidget(
                              classroom: classroom.key,
                              subject: subject,
                            ),
                      ],
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
