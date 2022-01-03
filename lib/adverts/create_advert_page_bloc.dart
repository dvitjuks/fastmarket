import 'dart:io';

import 'package:domain/model/advertisement.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/repository/advertisement_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/repository/image_upload_repository.dart';

class CreateAdvertPageState extends Equatable {
  final bool progress;
  final String imagePath;
  final String title;
  final String description;
  final String category;
  final ErrorType? error;
  final bool advertWasPublished;

  const CreateAdvertPageState(this.progress, this.imagePath, this.title,
      this.description, this.category, this.error, this.advertWasPublished);

  CreateAdvertPageState copyWith(
          {bool? progress,
          String? imagePath,
          String? title,
          String? description,
          String? category,
          ErrorType? error,
          bool? advertWasPublished}) =>
      CreateAdvertPageState(
          progress ?? this.progress,
          imagePath ?? this.imagePath,
          title ?? this.title,
          description ?? this.description,
          category ?? this.category,
          error,
          advertWasPublished ?? this.advertWasPublished);

  @override
  List<Object?> get props =>
      [progress, title, imagePath, description, category, error, advertWasPublished];

  bool canPublishAdvert() => title.isNotEmpty && description.isNotEmpty && category.isNotEmpty;
}

abstract class CreateAdvertPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetTitleEvent extends CreateAdvertPageEvent {
  final String title;

  SetTitleEvent(this.title);

  @override
  List<Object> get props => [title];
}

class SetCategoryEvent extends CreateAdvertPageEvent {
  final String category;

  SetCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class SetDescriptionEvent extends CreateAdvertPageEvent {
  final String description;

  SetDescriptionEvent(this.description);

  @override
  List<Object> get props => [description];
}

class SetImagePathEvent extends CreateAdvertPageEvent {
  final String path;

  SetImagePathEvent(this.path);

  @override
  List<Object> get props => [path];
}

class PublishEvent extends CreateAdvertPageEvent {}

class ClearErrorEvent extends CreateAdvertPageEvent {}

class CreateAdvertPageBloc
    extends Bloc<CreateAdvertPageEvent, CreateAdvertPageState> {
  final AdvertisementRepository _advertisementRepository;
  final ImageUploadRepository _imageUploadRepository;

  CreateAdvertPageBloc(this._advertisementRepository, this._imageUploadRepository)
      : super(const CreateAdvertPageState(false, '', '', '', '', null, false));

  @override
  Stream<CreateAdvertPageState> mapEventToState(
      CreateAdvertPageEvent event) async* {
    if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is SetTitleEvent) {
      yield state.copyWith(title: event.title);
    } else if (event is SetCategoryEvent) {
      yield state.copyWith(category: event.category);
    } else if (event is SetDescriptionEvent) {
      yield state.copyWith(description: event.description);
    } else if (event is SetImagePathEvent) {
      yield state.copyWith(imagePath: event.path);
    } else if (event is PublishEvent) {
      yield* _mapPublishEventToState(event);
    }
  }

  Stream<CreateAdvertPageState> _mapPublishEventToState(PublishEvent event) async* {
    yield state.copyWith(progress: true);
    try {
      String? imageUrl;
      var adId = '';
      if (state.imagePath.isNotEmpty) {
        final file = File(state.imagePath);
        try {
          final imageInfo = await _imageUploadRepository.uploadAdvertImage(file);
          imageUrl = imageInfo.first;
          adId = imageInfo.last;
        } catch (ex, st) {
          Fimber.w("Couldn't upload advert image", stacktrace: st);
          state.copyWith(progress: false, error: ErrorType.generalError);
        }
      }
      var timeNow = DateTime.now();
      final advert = Advertisement(adId: adId, ownerId: '', createdAt: timeNow, title: state.title, description: state.description, category: state.category, imageUrl: imageUrl);
      await _advertisementRepository.publishAdvertisement(advert);
      yield state.copyWith(progress: false, advertWasPublished: true);
    } catch (ex, st) {
      Fimber.w("Couldn't publish advert", stacktrace: st);
      state.copyWith(progress: false, error: ErrorType.generalError);
    }
  }
}
