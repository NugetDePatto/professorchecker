import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/providers/biz_auth_provider.dart';
import '../../data/providers/interfaces/auth_intercaface.dart';

import '../app_pages.dart';

class AuthGuardMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    AuthProvider authProvider = BizAuthProvider();

    if (authProvider.isLogged()) {
      return null;
    }
    return const RouteSettings(name: Routes.LOGIN);
  }
}
