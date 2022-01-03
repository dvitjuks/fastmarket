import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/model/user_profile.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepository extends AuthRepository {
  final UserRepository _userRepository;
  final loginController = StreamController<void>();
  final logoutController = StreamController<void>();

  FirebaseAuthRepository(this._userRepository);

  Stream<void> loginSuccess() => loginController.stream;

  Stream<void> logoutSuccess() => logoutController.stream;

  @override
  Future<void> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return;
    } on FirebaseAuthException catch (ex) {
      Fimber.w("Failed to authorise user", ex: ex);
      if (ex.code == 'weak-password') {
        throw AppError(ErrorType.weakPassword);
      } else if (ex.code == 'email-already-in-use') {
        throw AppError(ErrorType.emailAlreadyExists);
      } else {
        throw AppError(ErrorType.generalError);
      }
    } catch (ex, st) {
      Fimber.w("Failed to authorise user", ex: ex, stacktrace: st);
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<void> createProfile(
      String? firstName, String? lastName, String? photoUrl) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final String? email = FirebaseAuth.instance.currentUser?.email;
    final DateTime? createdAt = FirebaseAuth.instance.currentUser?.metadata.creationTime;
    if (userId != null) {
      try {
        CollectionReference users = FirebaseFirestore.instance
            .collection('users');
        await users.doc(userId)
            .set(UserProfile(
                    userId: userId,
                    email: email,
                    firstName: firstName ?? "Name",
                    lastName: lastName ?? "Surname",
                    avatarUrl: photoUrl,
                    creationDate: createdAt)
                .toJson());
        await setUpUser(userId);
      } catch (ex, st) {
        Fimber.w("Failed to create user profile", ex: ex, stacktrace: st);
        throw AppError(ErrorType.createProfile);
      }
    } else {
      Fimber.w("Failed to get current user");
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await setUpUser(FirebaseAuth.instance.currentUser?.uid);
      return;
    } on FirebaseAuthException catch (ex) {
      Fimber.w("Failed to login", ex: ex);
      if (ex.code == 'invalid-email') {
        throw AppError(ErrorType.invalidEmail);
      } else if (ex.code == 'user-not-found') {
        throw AppError(ErrorType.userNotFound);
      } else if (ex.code == 'wrong-password') {
        throw AppError(ErrorType.wrongPassword);
      } else {
        throw AppError(ErrorType.generalError);
      }
    } catch (ex, st) {
      Fimber.w("Failed to login", ex: ex, stacktrace: st);
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (ex) {
      Fimber.w("Failed to send password reset email", ex: ex);
      if (ex.code == 'invalid-email') {
        throw AppError(ErrorType.invalidEmail);
      } else if (ex.code == 'user-not-found') {
        throw AppError(ErrorType.userNotFound);
      } else {
        throw AppError(ErrorType.generalError);
      }
    } catch (ex, st) {
      Fimber.w("Failed to send password reset email", ex: ex, stacktrace: st);
      throw AppError(ErrorType.generalError);
    }
  }

  Future<void> updatePassword(
      String email, String oldPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final cred =
            EmailAuthProvider.credential(email: email, password: oldPassword);
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword);
      } else {
        throw Exception("Failed to get current user");
      }
    } on FirebaseAuthException catch (ex) {
      Fimber.w("Failed to change password", ex: ex);
      if (ex.code == 'wrong-password') {
        throw AppError(ErrorType.wrongPassword);
      } else {
        throw AppError(ErrorType.generalError);
      }
    } catch (ex, st) {
      Fimber.w("Failed to change password", ex: ex, stacktrace: st);
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      logoutController.add(null);
    } catch (ex, st) {
      Fimber.w("Failed to logout", ex: ex, stacktrace: st);
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        final fullName = googleUser?.displayName;
        final avatarUrl = googleUser?.photoUrl;
        List<String> fullNameToDisplay;
        fullName != null
            ? fullNameToDisplay = fullName.split(" ")
            : fullNameToDisplay = ["", ""];
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          CollectionReference users = FirebaseFirestore.instance
              .collection('users');
          final noProfileYet = await users.doc(userId).get().then((value) => !value.exists);
          if (noProfileYet) {
            await createProfile(
                fullNameToDisplay.first, fullNameToDisplay.last, avatarUrl);
          } else {
            setUpUser(userId);
          }
        }

        return;
      } else {
        Fimber.w("Failed to login, google user is null");
        throw AppError(ErrorType.generalError);
      }
    } on FirebaseAuthException catch (ex) {
      Fimber.w("Failed to login", ex: ex);
      if (ex.code == 'account-exists-with-different-credential') {
        throw AppError(ErrorType.accountExistsWithDifferentCredential);
      } else {
        throw AppError(ErrorType.generalError);
      }
    } catch (ex, st) {
      Fimber.w("Failed to login", ex: ex, stacktrace: st);
      throw AppError(ErrorType.generalError);
    }
  }

  Future<void> setUpUser(String? userId) async {
    if (userId == null) throw Exception('UserID is null');
    await _userRepository.loadUser(false);
    loginController.add(null);
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      await FirebaseAuth.instance.signOut();
      logoutController.add(null);
    } catch (ex, st) {
      Fimber.w("Failed to delete account", ex: ex, stacktrace: st);
      throw AppError(ErrorType.deleteProfile);
    }
  }
}
