
import 'package:domain/repository/auth_repository.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocState extends Equatable {
  final bool loadedUser;
  final bool error;

  const AppBlocState(this.loadedUser, this.error);

  AppBlocState copyWith(
      {bool? loadedUser, bool? error}) =>
      AppBlocState(loadedUser ?? this.loadedUser, error ?? this.error);

  @override
  List<Object?> get props => [loadedUser, error];
}

abstract class AppBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckSessionEvent extends AppBlocEvent {}

class SetUpUserEvent extends AppBlocEvent {}

class ClearErrorEvent extends AppBlocEvent {}

class AppBloc extends Bloc<AppBlocEvent, AppBlocState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AppBloc(this._authRepository, this._userRepository,)
      : super(const AppBlocState(false, false));

  Stream<void> loginSuccess() => _authRepository.loginSuccess();

  Stream<void> logoutSuccess() => _authRepository.logoutSuccess();

  @override
  Stream<AppBlocState> mapEventToState(AppBlocEvent event) async* {
    if (event is SetUpUserEvent) {
      yield* _mapSetUpUserEventToState();
    } else if (event is ClearErrorEvent) {
      yield state.copyWith(error: false);
    }
  }

  Stream<AppBlocState> _mapSetUpUserEventToState() async* {
    try {
      //await _userRepository.loadUser(false);
      print("after user loaded");
      yield state.copyWith(loadedUser: true);
    } catch (ex, st) {
      Fimber.e("Can't load user profile",
          ex: ex, stacktrace: st);
      yield state.copyWith(error: true);
    }
  }

  Future<void> clearPossiblyCachedCredentials() async {
    await _authRepository.logout();
  }
}
