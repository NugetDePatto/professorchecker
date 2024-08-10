import 'package:get/get.dart';

import '../../../data/providers/biz_auth_provider.dart';
import '../../../data/providers/interfaces/auth_intercaface.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    Get.lazyPut<AuthProvider>(
      () => BizAuthProvider(),
    );
  }
}
