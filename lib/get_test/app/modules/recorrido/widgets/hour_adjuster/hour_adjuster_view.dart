import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/colors_theme.dart';
import 'hour_adjuster_controller.dart';

class HourAdjusterView extends GetView<HourAdjusterController> {
  const HourAdjusterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              controller.decrementHour();
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 30,
              color: ColorsTheme.buttonTextColor,
            ),
          ),
          Obx(
            () => Text(
              controller.currentHourRx.value,
              style: const TextStyle(
                color: ColorsTheme.buttonTextColor,
                fontSize: 20,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              controller.incrementHour();
            },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 30,
              color: ColorsTheme.buttonTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
