import 'package:checadordeprofesores/app/modules/images/controllers/up_image_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<UpImageContoller>(
      () => UpImageContoller(),
    );
  }
}
