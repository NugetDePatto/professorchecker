import 'package:get/get.dart';

import '../controllers/professors_reports_controller.dart';

class ProfessorsReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfessorsReportsController>(
      () => ProfessorsReportsController(),
    );
  }
}
