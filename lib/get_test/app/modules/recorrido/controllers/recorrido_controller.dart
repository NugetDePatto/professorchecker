import 'package:get/get.dart';

import '../../../data/providers/interfaces/auth_intercaface.dart';
import '../../../routes/app_pages.dart';

class RecorridoController extends GetxController {
  AuthProvider? authProvider = Get.find<AuthProvider>();

  final count = 0.obs;

  void increment() => count.value++;

  Future<void> login() async {
    await authProvider!.login();
    if (authProvider!.isLogged()) {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
