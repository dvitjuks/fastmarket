import 'dart:io';

import 'package:domain/model/advertisement.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/repository/image_upload_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FireBaseImagesStorageRepository extends ImageUploadRepository {
  @override
  Future<void> deleteAvatar(String fileName) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final Reference ref = getAvatarReference(fileName, userId);
    await ref.delete();
  }

  @override
  Future<List<String>> uploadAvatar(File file, String extension) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        var uuid = const Uuid();
        final name = uuid.v4();
        final fileName = name + extension;
        final Reference ref = getAvatarReference(fileName, userId);
        await ref.putFile(file);
        final List<String> list = [];
        final url = await ref.getDownloadURL();
        list.add(url);
        list.add(fileName);
        return list;
      } catch (ex, st) {
        Fimber.w("Failed to upload image", stacktrace: st, ex: ex);
        throw AppError(ErrorType.generalError);
      }
    } else {
      Fimber.w("You are unauthorized, please log in");
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<List<String>> uploadAdvertImage(File file) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      var uuid = const Uuid();
      final id = uuid.v4();
      final Reference ref = getAdvertImageReference(id);
      await ref.putFile(file);
      final List<String> list = [];
      final url = await ref.getDownloadURL();
      list.add(url);
      list.add(id);
      return list;
    } else {
      Fimber.w("You are unauthorized, please log in");
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<void> deleteAdvertImage(Advertisement advertisement) async {
    final Reference ref = getAdvertImageReference(advertisement.adId);
    await ref.delete();
  }
}

Reference getAvatarReference(String fileName, String? userId) {
  return FirebaseStorage.instance
      .ref()
      .child('user_avatars')
      .child('$userId')
      .child(fileName);
}

Reference getAdvertImageReference(String id) {
  return FirebaseStorage.instance.ref().child('adverts').child(id).child(id);
}
