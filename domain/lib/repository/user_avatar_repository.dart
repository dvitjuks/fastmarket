import 'dart:io';

abstract class UserAvatarRepository {
  Future<void> deleteFile(String fileName);

  Future<String> getUrl(String uuid);

  Future<List<String>> uploadFile(File file, String extension);
}