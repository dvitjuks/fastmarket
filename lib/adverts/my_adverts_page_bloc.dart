import 'package:domain/model/advertisement.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/repository/advertisement_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAdvertsPageState extends Equatable {
  final bool progress;
  final bool loadingNewData;
  final List<Advertisement> allAdverts;
  final ErrorType? error;

  const MyAdvertsPageState(
      this.progress, this.loadingNewData, this.allAdverts, this.error);

  MyAdvertsPageState copyWith(
          {bool? progress,
          bool? loadingNewData,
          List<Advertisement>? allAdverts,
          ErrorType? error}) =>
      MyAdvertsPageState(
          progress ?? this.progress,
          loadingNewData ?? this.loadingNewData,
          allAdverts ?? this.allAdverts,
          error);

  @override
  List<Object?> get props => [progress, loadingNewData, allAdverts, error];
}

abstract class MyAdvertsPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends MyAdvertsPageEvent {}

class ClearErrorEvent extends MyAdvertsPageEvent {}

class LoadMoreEvent extends MyAdvertsPageEvent {}

class DeleteAdvertEvent extends MyAdvertsPageEvent {
  final Advertisement advert;
  final int index;

  DeleteAdvertEvent(this.advert, this.index);

  @override
  List<Object> get props => [advert, index];
}

class MyAdvertsPageBloc extends Bloc<MyAdvertsPageEvent, MyAdvertsPageState> {
  final AdvertisementRepository _advertisementRepository;

  MyAdvertsPageBloc(this._advertisementRepository)
      : super(MyAdvertsPageState(false, false, [], null));

  Stream<void> refreshStream() => _advertisementRepository.refreshStream();

  @override
  Stream<MyAdvertsPageState> mapEventToState(MyAdvertsPageEvent event) async* {
    if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is LoadEvent) {
      yield* _mapLoadEventToState();
    } else if (event is LoadMoreEvent) {
      yield* _mapLoadMoreEventToState();
    } else if (event is DeleteAdvertEvent) {
      yield* _mapDeleteAdvertEventToState(event);
    }
  }

  Stream<MyAdvertsPageState> _mapLoadEventToState() async* {
    yield state.copyWith(progress: true, loadingNewData: true);
    try {
      var adverts = await _advertisementRepository.getMyAdvertisements();
      yield state.copyWith(
          progress: false, loadingNewData: false, allAdverts: adverts);
    } catch (ex, st) {
      Fimber.w("Failed to load initial adverts", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false,
          loadingNewData: false);
    }
  }

  Stream<MyAdvertsPageState> _mapLoadMoreEventToState() async* {
    yield state.copyWith(loadingNewData: true);
    try {
      final canLoadMore = _advertisementRepository.canLoadMoreMyAdverts;
      List<Advertisement> nextAdverts = [];
      if (canLoadMore) {
        nextAdverts = await _advertisementRepository.getMoreMyAdvertisements();
      }
      yield state.copyWith(
          allAdverts: state.allAdverts + nextAdverts, loadingNewData: false);
    } catch (ex, st) {
      Fimber.w("Failed to load more advertisements", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: ex is AppError ? ex.type : ErrorType.generalError,
          loadingNewData: false);
    }
  }

  Stream<MyAdvertsPageState> _mapDeleteAdvertEventToState(
      DeleteAdvertEvent event) async* {
    yield state.copyWith(progress: true, loadingNewData: true);
    try {
      _advertisementRepository.deleteAdvertisement(event.advert);
      var adverts = await _advertisementRepository.getMyAdvertisements();
      yield state.copyWith(
          progress: false, loadingNewData: false, allAdverts: adverts);
    } catch (ex, st) {
      Fimber.w("Failed to delete advertisement", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false,
          loadingNewData: false);
    }
  }
}
