import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../widgets/appbar_widget.dart';
import '../controllers/recorrido_controller.dart';
import '../widgets/blocks_buttons/blocks_buttons_view.dart';
import '../widgets/interval_adjuster/interval_adjuster_controller.dart';
import '../widgets/interval_adjuster/interval_adjuster_view.dart';

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
      body: const Column(
        children: [
          IntervalAdjusterView(),
          BlocksButtonsView(),
        ],
      ),
    );
  }
}
