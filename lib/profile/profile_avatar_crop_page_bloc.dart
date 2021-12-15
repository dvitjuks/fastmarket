import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:domain/model/error_type.dart';
import 'package:domain/repository/user_avatar_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AddPhotoCropState extends Equatable {
  final String? uploadedUrl;
  final String? uploadedFilename;

  final bool isLoading;
  final ErrorType? errorType;
  final bool shouldDisableButtons;

  AddPhotoCropState(this.uploadedUrl, this.uploadedFilename, this.isLoading, this.errorType,
      this.shouldDisableButtons);

  AddPhotoCropState copyWith(
          {String? uploadedUrl,
            String? uploadedFilename,
          bool? isLoading,
          ErrorType? errorType,
          bool? shouldDisableButtons}) =>
      AddPhotoCropState(
          uploadedUrl ?? this.uploadedUrl,
          uploadedFilename ?? this.uploadedFilename,
          isLoading ?? this.isLoading,
          errorType ?? this.errorType,
          shouldDisableButtons ?? this.shouldDisableButtons);

  bool addPhotoButtonsLoading() => isLoading && !shouldDisableButtons;

  @override
  List<Object?> get props =>
      [uploadedUrl, uploadedFilename, isLoading, errorType, shouldDisableButtons];
}

abstract class AddPhotoCropEvent extends Equatable {
  const AddPhotoCropEvent();

  @override
  List<Object> get props => [];
}

class AddPhotoCropUploadEvent extends AddPhotoCropEvent {
  final Uint8List fileData;

  const AddPhotoCropUploadEvent(this.fileData);

  @override
  List<Object> get props => [fileData];
}

class AddPhotoCropBloc extends Bloc<AddPhotoCropEvent, AddPhotoCropState> {
  final UserAvatarRepository _userAvatarRepository;

  AddPhotoCropBloc(this._userAvatarRepository)
      : super(AddPhotoCropState(null, null, false, null, false));

  @override
  Stream<AddPhotoCropState> mapEventToState(AddPhotoCropEvent event) async* {
    if (event is AddPhotoCropUploadEvent) {
      yield* _mapUploadEvent(event);
    }
  }

  Stream<AddPhotoCropState> _mapUploadEvent(
      AddPhotoCropUploadEvent event) async* {
    yield state.copyWith(
        isLoading: true, shouldDisableButtons: true);
    try {
      Uint8List imageInUnit8List = event.fileData;
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(imageInUnit8List);
      final ext = extension(file.path);
      final imgData = await _userAvatarRepository.uploadFile(
          file, ext);
      yield state.copyWith(isLoading: false, uploadedUrl: imgData.first, uploadedFilename: imgData.last);
    } catch (ex, st) {
      Fimber.w("Failed to upload profile avatar", ex: ex, stacktrace: st);
      yield state.copyWith(
          isLoading: false, errorType: ErrorType.generalError);
    }
  }
}
