import 'package:domain/model/error_type.dart';
import 'package:domain/model/user_profile.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseUserRepository extends UserRepository {
  UserProfile? _userProfile;

  FirebaseUserRepository();

  @override
  Future<UserProfile> loadUser(bool useDataFromCache) async {
    var currentUser = _userProfile;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final email = FirebaseAuth.instance.currentUser?.email ?? "";
    final creationDate =
        FirebaseAuth.instance.currentUser?.metadata.creationTime;
    try {
      if (useDataFromCache && currentUser != null) {
        return currentUser;
      } else if (userId != null) {
        final userFromFirebase = await FirebaseDatabase.instance
            .reference()
            .child("users/")
            .child(userId)
            .child("user_profile")
            .once()
            .then((value) {
          return UserProfile.fromJson(Map<String, dynamic>.from(value.value))
              .copyWith(
              email: email,
              creationDate: creationDate);
        });
        _userProfile = userFromFirebase;
        return userFromFirebase;
      } else {
        Fimber.w("Trying to load profile while unauthorised");
        throw AppError(ErrorType.unauthorised);
      }
    } catch (ex, st) {
      Fimber.w("Failed to load profile: userId: $userId, email: $email",
          stacktrace: st, ex: ex);
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<void> saveUser(UserProfile userProfile) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await FirebaseDatabase.instance
            .reference()
            .child("users/")
            .child(userId)
            .child("user_profile")
            .set(userProfile.toJson());
        return;
      } catch (ex, st) {
        Fimber.w("Failed to save user", ex: ex, stacktrace: st);
        throw AppError(ErrorType.saveProfile);
      }
    } else {
      Fimber.w("Failed to get current user");
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<void> deleteUser() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await FirebaseDatabase.instance
            .reference()
            .child("users/")
            .child(userId)
            .remove();
      } catch (ex, st) {
        Fimber.w("Failed to delete user", ex: ex, stacktrace: st);
        throw AppError(ErrorType.deleteProfile);
      }
    } else {
      Fimber.w("Failed to get current user");
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  UserProfile? get userProfile => _userProfile;
}
