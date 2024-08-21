import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/colors_theme.dart';
import '../../../../core/utlis/dispose_util.dart';
import '../controllers/recorrido_controller.dart';
import '../widgets/subject_card/icon_button_widget.dart';

class DayAdjusterView extends GetView<RecorridoController> {
  const DayAdjusterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getSize(25), vertical: getSize(10)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.max,
        children: [
          if (kDebugMode)
            IconButtonWidget(
              onPressed: controller.decrementDay,
              icon: Icons.arrow_back_ios_rounded,
              isSelected: false,
              color: ColorsTheme.accentColor,
            ),
          Obx(
            () => Expanded(
              child: Text(
                controller.currentDay.value.toString(),
                style: TextStyle(
                  color: ColorsTheme.textColor,
                  fontSize: getSize(20),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (kDebugMode)
            IconButtonWidget(
              onPressed: controller.incrementDay,
              icon: Icons.arrow_forward_ios_rounded,
              isSelected: false,
              color: ColorsTheme.accentColor,
            ),
        ],
      ),
    );
  }
}
