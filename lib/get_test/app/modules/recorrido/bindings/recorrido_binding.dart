import 'package:checadordeprofesores/get_test/app/modules/recorrido/widgets/hour_adjuster/hour_adjuster_controller.dart';
import 'package:get/get.dart';

import '../../../data/providers/biz_auth_provider.dart';
import '../../../data/providers/interfaces/auth_intercaface.dart';
import '../controllers/recorrido_controller.dart';

class RecorridoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecorridoController>(
      () => RecorridoController(),
    );
    Get.lazyPut<AuthProvider>(
      () => BizAuthProvider(),
    );
    Get.lazyPut<HourAdjusterController>(
      () => HourAdjusterController(),
    );
  }
}
