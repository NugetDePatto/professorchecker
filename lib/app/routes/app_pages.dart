import 'package:checadordeprofesores/app/modules/reports/bindings/reports_binding.dart';
import 'package:checadordeprofesores/app/modules/reports/views/classroom_reports_view.dart';
import 'package:checadordeprofesores/app/modules/reports/views/professors_reports_view.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/recorrido/bindings/recorrido_binding.dart';
import '../modules/recorrido/views/recorrido_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.RECORRIDO,
      page: () => const RecorridoView(),
      binding: RecorridoBinding(),
    ),
    GetPage(
      name: _Paths.PROFESSOR_REPORTS,
      page: () => const ProfessorsReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: _Paths.CLASSROOMS_REPORTS,
      page: () => const ClassroomReportsView(),
      binding: ReportsBinding(),
    ),
  ];
}
