import 'interfaces/auth_intercaface.dart';

class BizAuthProvider implements AuthProvider {
  @override
  Future<int> login() async {
    return 42;
  }

  @override
  Future<void> logout() async {}

  @override
  bool isLogged() {
    return false;
  }
}
