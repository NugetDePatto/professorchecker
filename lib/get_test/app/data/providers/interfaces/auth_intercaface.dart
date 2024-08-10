abstract class AuthProvider {
  Future login();
  Future<void> logout();
  bool isLogged();
}
