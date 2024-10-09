import 'package:checadordeprofesores/app/modules/images/views/up_images_dialog.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  attendanceButton() {
    Get.toNamed('/recorrido');
  }

  imagesButton() {
    upImagesDialog();
  }
}
