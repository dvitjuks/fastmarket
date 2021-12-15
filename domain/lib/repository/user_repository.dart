import 'package:domain/model/user_profile.dart';

abstract class UserRepository {
  UserProfile? get userProfile;

  Future<UserProfile> loadUser(bool useDataFromCache);

  Future<void> saveUser(UserProfile userProfile);

  Future<void> deleteUser();
}
