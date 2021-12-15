import 'package:domain/model/error_type.dart';
import 'package:domain/model/user_profile.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageState extends Equatable {
  final bool progress;
  final UserProfile? userProfile;
  final ErrorType? error;

  MainPageState(this.progress, this.userProfile, this.error);

  MainPageState copyWith(
      {bool? progress,
        UserProfile? userProfile,
        ErrorType? error}) =>
      MainPageState(progress ?? this.progress, userProfile ?? this.userProfile, error);


  @override
  List<Object?> get props => [progress, userProfile, error];
}

abstract class MainPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends MainPageEvent {}

class ClearErrorEvent extends MainPageEvent {}

class LogoutEvent extends MainPageEvent {}

class MainPageBloc
    extends Bloc<MainPageEvent, MainPageState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  MainPageBloc(this._authRepository, this._userRepository)
      : super(MainPageState(false, null, null));

  @override
  Stream<MainPageState> mapEventToState(
      MainPageEvent event) async* {
    if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is LogoutEvent) {
      yield* _mapLogoutEventToState();
    } else if (event is LoadEvent) {
      yield* _mapLoadEventToState();
    }
  }

  Stream<MainPageState> _mapLoadEventToState() async* {
    try {
      // final user = await _userRepository.loadUser(false);
      // yield state.copyWith(userProfile: user);
    } catch (ex, st) {
      Fimber.w("Failed to log out", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError)
      );
    }
  }

  Stream<MainPageState> _mapLogoutEventToState() async* {
    yield state.copyWith(progress: true);
    try {
      await _authRepository.logout();
      yield state.copyWith(progress: false);
    } catch (ex, st) {
      Fimber.w("Failed to log out", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false);
    }
  }
}
