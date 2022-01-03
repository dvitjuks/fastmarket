import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/model/user_profile.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepository extends UserRepository {
  UserProfile? _userProfile;
  final _usersRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserProfile>(
        fromFirestore: (snapshot, _) => UserProfile.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

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
        UserProfile userFromFirebase = await _usersRef
            .doc(userId)
            .get()
            .then((snapshot) => snapshot.data()!);
        _userProfile =
            userFromFirebase.copyWith(email: email, creationDate: creationDate);
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
    final email = FirebaseAuth.instance.currentUser?.email;
    final creationDate =
        FirebaseAuth.instance.currentUser?.metadata.creationTime;
    if (userId != null) {
      try {
        await _usersRef.doc(userId).set(
            userProfile.copyWith(email: email, creationDate: creationDate));
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
        await _usersRef.doc(userId).delete();
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

  @override
  Future<UserProfile?> getUserById(String id) async {
    try {
      final userSnapshot =
          await _usersRef.doc(id).get().then((snapshot) => snapshot);
      if (userSnapshot.exists) {
        return userSnapshot.data()!;
      } else {
        Fimber.w("User with that id doesn't exist");
        return null;
      }
    } catch (ex, st) {
      Fimber.w("Failed to get user info", ex: ex, stacktrace: st);
      throw AppError(ErrorType.userNotFound);
    }
  }
}
