import 'package:get/get.dart';

import '../controllers/recorrido_controller.dart';

class RecorridoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecorridoController>(
      () => RecorridoController(),
    );
    // Get.lazyPut<SubjectCardController>(
    //   () => SubjectCardController(),
    // );
  }
}
