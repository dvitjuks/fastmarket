abstract class AuthRepository {
  Future<void> signUp(String email, String password);

  Future<void> createProfile(
      String firstName, String lastName, String? photoUrl);

  Future<void> login(String email, String password);

  Future<void> forgotPassword(String email);

  Future<void> updatePassword(
      String email, String oldPassword, String newPassword);

  Future<void> signInWithGoogle();

  Future<void> logout();

  Stream<void> loginSuccess();

  Stream<void> logoutSuccess();

  Future<void> deleteAccount();
}