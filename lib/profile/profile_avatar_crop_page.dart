import 'dart:io';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:fastmarket/profile/profile_add_avatar_popup.dart';
import 'package:fastmarket/profile/profile_avatar_crop_page_bloc.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_loading_button.dart';
import 'package:fastmarket/theme/ct_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddPhotoCropPage extends StatefulWidget {
  final File file;
  final ImageSource source;
  final UploadImageCallback callback;

  AddPhotoCropPage(this.file, this.source, this.callback);

  @override
  _AddPhotoCropPageState createState() => _AddPhotoCropPageState(
        file,
        source,
        callback,
      );

  static Widget withBloc(
      UploadImageCallback callback, File file, ImageSource source) {
    return BlocProvider(
        child: AddPhotoCropPage(file, source, callback),
        create: (context) => AddPhotoCropBloc(context.read()));
  }
}

class _AddPhotoCropPageState extends State<AddPhotoCropPage> {
  late AddPhotoCropBloc _bloc;
  final CropController _controller = CropController();

  File file;
  ImageSource source;

  UploadImageCallback uploadCallback;

  _AddPhotoCropPageState(this.file, this.source, this.uploadCallback);

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddPhotoCropBloc, AddPhotoCropState>(
        listener: (context, state) {
      if (state.errorType != null) {
        Scaffold.of(context).showSnackBar(CTSnackBar(
          text: state.errorType.toString(),
        ));
        Navigator.pop(context);
      } else if (state.uploadedUrl != null && state.uploadedFilename != null) {
        final url = state.uploadedUrl;
        final fileName = state.uploadedFilename;
        uploadCallback(url!, fileName!);
        Navigator.pop(context);
      }
    }, child: BlocBuilder<AddPhotoCropBloc, AddPhotoCropState>(
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
          child: Column(children: [
            Expanded(
                child: Stack(children: [
              state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Crop(
                      image: file.readAsBytesSync(),
                      controller: _controller,
                      aspectRatio: 1,
                      withCircleUi: true,
                      onCropped: (image) {
                        _bloc.add(AddPhotoCropUploadEvent(image));
                      },
                    ),
              Positioned(
                top: 12,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: AppColors.background1,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ])),
            _buildButtons(context)
          ]),
        ));
      },
    ));
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 24.0, bottom: 32.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CTLoadingButton(
                  source == ImageSource.camera
                      ? "Retake photo"
                      : "Choose another",
                  _bloc.state.shouldDisableButtons
                      ? () {}
                      : () async {
                          final imagePicker = ImagePicker();
                          final xFile =
                              await imagePicker.pickImage(source: source);
                          if (xFile != null) {
                            file = File(xFile.path);
                          }
                          setState(() {});
                        },
                  color: AppColors.patternBlue,
                  isLoading: _bloc.state.addPhotoButtonsLoading()),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: CTLoadingButton(
                "Upload",
                _bloc.state.shouldDisableButtons
                    ? () {}
                    : () {
                        _controller.crop();
                      },
                color: AppColors.patternBlue,
                isLoading: _bloc.state.addPhotoButtonsLoading(),
              ),
            )
          ],
        ));
  }
}
