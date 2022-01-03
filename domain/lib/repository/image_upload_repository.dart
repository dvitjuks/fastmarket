import 'dart:io';

import 'package:domain/model/advertisement.dart';

abstract class ImageUploadRepository {
  Future<void> deleteAvatar(String fileName);

  Future<List<String>> uploadAvatar(File file, String extension);

  Future<List<String>> uploadAdvertImage(File file);

  Future<void> deleteAdvertImage(Advertisement advertisement);
}
