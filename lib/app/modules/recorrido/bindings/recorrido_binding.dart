import 'package:get/get.dart';

import '../controllers/recorrido_controller.dart';
import '../widgets/blocks_buttons/blocks_buttons_controller.dart';
import '../widgets/interval_adjuster/interval_adjuster_controller.dart';

class RecorridoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecorridoController>(
      () => RecorridoController(),
    );
    Get.lazyPut<IntervalAdjusterController>(
      () => IntervalAdjusterController(),
    );
    Get.lazyPut<BlocksButtonsController>(
      () => BlocksButtonsController(),
    );
  }
}
