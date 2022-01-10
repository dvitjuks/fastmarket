import 'package:domain/model/advertisement.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/repository/advertisement_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllAdvertsPageState extends Equatable {
  //State's main parameters
  final bool progress;
  final bool loadingNewData;
  final List<Advertisement> allAdverts;
  final String selectedCategory;
  final ErrorType? error;

  const AllAdvertsPageState(this.progress, this.loadingNewData, this.allAdverts,
      this.selectedCategory, this.error);

  //Copy constructor to update the state with new values
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
//Event to load initial data
class LoadEvent extends AllAdvertsPageEvent {}

//Event to clear error state
class ClearErrorEvent extends AllAdvertsPageEvent {}

//Event to change category
class SetCategoryEvent extends AllAdvertsPageEvent {
  final String category;

  SetCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

//Event on pagination request
class LoadMoreEvent extends AllAdvertsPageEvent {}

class AllAdvertsPageBloc
    extends Bloc<AllAdvertsPageEvent, AllAdvertsPageState> {
  //Advert repository to use firestore functions
  final AdvertisementRepository _advertisementRepository;

  //Default constructor of bloc has "All Categories" selected
  AllAdvertsPageBloc(this._advertisementRepository)
      : super(AllAdvertsPageState(false, false, [], "All categories", null));

  //Stream to listen for refresh request from advert repository
  Stream<void> refreshStream() => _advertisementRepository.refreshStream();

  @override
  //Map incoming event to correct stream
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
    //Show loading indicator while loading
    yield state.copyWith(progress: true, loadingNewData: true);
    try {
      //Get the first batch of adverts from firestore
      var adverts = await _advertisementRepository
          .getAdvertisements(state.selectedCategory);
      //Yield state with first batch of adverts and cancel loading indicator
      yield state.copyWith(
          progress: false, loadingNewData: false, allAdverts: adverts);
    } catch (ex, st) {
      //On error throw error and log the stacktrace, cancel loading
      Fimber.w("Failed to load initial adverts", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false,
          loadingNewData: false);
    }
  }

  Stream<AllAdvertsPageState> _mapSetCategoryEventToState(
      SetCategoryEvent event) async* {
    //Show loading indicator while loading
    yield state.copyWith(progress: true, loadingNewData: true);
    try {
      //Load first adverts from selected category
      var adverts =
          await _advertisementRepository.getAdvertisements(event.category);
      //Yield updated state with new loaded adverts and selected category
      //Don't forget to cancel loading indicator
      yield state.copyWith(
          progress: false,
          loadingNewData: false,
          allAdverts: adverts,
          selectedCategory: event.category);
    } catch (ex, st) {
      //On error throw error and log the stacktrace, cancel loading
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
      //Check if selected category can load more
      final canLoadMore = _advertisementRepository.canLoadMore;
      List<Advertisement> nextAdverts = [];
      if (canLoadMore) {
        //Load next paginated adverts
        nextAdverts = await _advertisementRepository
            .getMoreAdvertisements(state.selectedCategory);
      }
      //Yield updated state with concatenated next adverts, cancel the loading indicator
      yield state.copyWith(
          allAdverts: state.allAdverts + nextAdverts, loadingNewData: false);
    } catch (ex, st) {
      //On error throw error and log the stacktrace, cancel loading
      Fimber.w("Failed to load more advertisements", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: ex is AppError ? ex.type : ErrorType.generalError,
          loadingNewData: false);
    }
  }
}
