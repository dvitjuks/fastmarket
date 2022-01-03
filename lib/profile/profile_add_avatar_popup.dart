import 'dart:io';

import 'package:fastmarket/profile/profile_avatar_crop_page.dart';
import 'package:fastmarket/theme/ct_popup.dart';
import 'package:fastmarket/theme/ct_popup_action.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileAvatarPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static void showPhotoOptions(
      BuildContext context, UploadImageCallback uploadFileCallback,
      {bool onRegistration = false}) async {
    final popup = FMPopup(
      title: null,
      actions: <Widget>[
        _takeAPhotoAction(context, uploadFileCallback, onRegistration),
        _uploadFromGalleryAction(context, uploadFileCallback, onRegistration),
      ],
    );
    await popup.selectedValue(context);
  }

  static Widget _takeAPhotoAction(BuildContext context,
      UploadImageCallback uploadFileCallback, bool onRegistration) {
    return FMPopupAction(
      onPressed: () {
        Navigator.pop(context);
        _selectImage(
            context, ImageSource.camera, uploadFileCallback, onRegistration);
      },
      title: "Take a photo",
    );
  }

  static Widget _uploadFromGalleryAction(BuildContext context,
      UploadImageCallback uploadFileCallback, bool onRegistration) {
    return FMPopupAction(
      onPressed: () {
        Navigator.pop(context);
        _selectImage(
            context, ImageSource.gallery, uploadFileCallback, onRegistration);
      },
      title: "Upload from gallery",
    );
  }

  static void _selectImage(BuildContext context, ImageSource source,
      UploadImageCallback uploadFileCallback, bool onRegistration) async {
    await grandPermission(context, source);
    final imagePicker = ImagePicker();
    final xFile = await imagePicker.pickImage(
        source: source, preferredCameraDevice: CameraDevice.front);
    if (xFile != null) {
      final file = File(xFile.path);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddPhotoCropPage.withBloc(uploadFileCallback, file, source)));
    }
  }

  static Future<void> grandPermission(
      BuildContext context, ImageSource source) async {
    if (source == ImageSource.camera &&
        await Permission.camera.status.isDenied) {
      await Permission.camera.request();
    } else if (source == ImageSource.gallery &&
        await Permission.photos.status.isDenied) {
      await Permission.photos.request();
    }
  }
}

typedef UploadImageCallback = void Function(String url, String filename);
