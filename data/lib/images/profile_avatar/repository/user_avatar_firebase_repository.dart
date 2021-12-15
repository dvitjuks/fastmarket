import 'dart:io';

import 'package:domain/model/error_type.dart';
import 'package:domain/repository/user_avatar_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UserAvatarFirebaseRepository extends UserAvatarRepository {
  @override
  Future<void> deleteFile(String fileName) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final Reference ref = getReference(fileName, userId);
    await ref.delete();
  }

  @override
  Future<String> getUrl(String uuid) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final fileName = uuid + '.pdf';
    final Reference ref = getReference(fileName, userId);
    return await ref.getDownloadURL();
  }

  @override
  Future<List<String>> uploadFile(File file, String extension) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
          var uuid = const Uuid();
          final name = uuid.v4();
          final fileName = name + extension;
          final Reference ref = getReference(fileName, userId);
          await ref.putFile(file);
          final List<String> list = [];
          final url = await ref.getDownloadURL();
          list.add(url);
          list.add(fileName);
          return list;
      } catch (ex, st) {
        Fimber.w("Failed to upload image",
            stacktrace: st, ex: ex);
        throw AppError(ErrorType.generalError);
      }
    } else {
      return [];
    }
  }
}

Reference getReference(String fileName, String? userId) {
  return FirebaseStorage.instance
      .ref()
      .child('user_avatars')
      .child('$userId')
      .child(fileName);
}
