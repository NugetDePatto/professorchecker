import 'package:get/get.dart';

import '../controllers/foo_controller.dart';

class FooBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FooController>(
      () => FooController(),
    );
  }
}
