import 'package:domain/model/advertisement.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/repository/advertisement_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllAdvertsPageState extends Equatable {
  final bool progress;
  final bool loadingNewData;
  final List<Advertisement> allAdverts;
  final String selectedCategory;
  final ErrorType? error;

  const AllAdvertsPageState(this.progress, this.loadingNewData, this.allAdverts,
      this.selectedCategory, this.error);

  AllAdvertsPageState copyWith(
          {bool? progress,
          bool? loadingNewData,
          List<Advertisement>? allAdverts,
          String? selectedCategory,
          ErrorType? error}) =>
      AllAdvertsPageState(
          progress ?? this.progress,
          loadingNewData ?? this.loadingNewData,
          allAdverts ?? this.allAdverts,
          selectedCategory ?? this.selectedCategory,
          error);

  @override
  List<Object?> get props =>
      [progress, loadingNewData, allAdverts, selectedCategory, error];
}

abstract class AllAdvertsPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends AllAdvertsPageEvent {}

class ClearErrorEvent extends AllAdvertsPageEvent {}

class SetCategoryEvent extends AllAdvertsPageEvent {
  final String category;

  SetCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class LoadMoreEvent extends AllAdvertsPageEvent {}

class AllAdvertsPageBloc
    extends Bloc<AllAdvertsPageEvent, AllAdvertsPageState> {
  final AdvertisementRepository _advertisementRepository;

  AllAdvertsPageBloc(this._advertisementRepository)
      : super(AllAdvertsPageState(false, false, [], "All categories", null));

  Stream<void> refreshStream() => _advertisementRepository.refreshStream();

  @override
  Stream<AllAdvertsPageState> mapEventToState(
      AllAdvertsPageEvent event) async* {
    if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is LoadEvent) {
      yield* _mapLoadEventToState();
    } else if (event is SetCategoryEvent) {
      yield* _mapSetCategoryEventToState(event);
    } else if (event is LoadMoreEvent) {
      yield* _mapLoadMoreEventToState();
    }
  }

  Stream<AllAdvertsPageState> _mapLoadEventToState() async* {
    yield state.copyWith(progress: true, loadingNewData: true);
    try {
      var adverts = await _advertisementRepository
          .getAdvertisements(state.selectedCategory);
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

  Stream<AllAdvertsPageState> _mapSetCategoryEventToState(
      SetCategoryEvent event) async* {
    yield state.copyWith(progress: true, loadingNewData: true);
    try {
      var adverts =
          await _advertisementRepository.getAdvertisements(event.category);
      yield state.copyWith(
          progress: false,
          loadingNewData: false,
          allAdverts: adverts,
          selectedCategory: event.category);
    } catch (ex, st) {
      Fimber.w("Failed to load initial adverts", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false,
          loadingNewData: false);
    }
  }

  Stream<AllAdvertsPageState> _mapLoadMoreEventToState() async* {
    yield state.copyWith(loadingNewData: true);
    try {
      final canLoadMore = _advertisementRepository.canLoadMore;
      List<Advertisement> nextAdverts = [];
      if (canLoadMore) {
        nextAdverts = await _advertisementRepository
            .getMoreAdvertisements(state.selectedCategory);
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
}
