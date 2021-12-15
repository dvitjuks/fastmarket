import 'package:domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/model/error_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fimber/fimber.dart';

class MainLoginPageState extends Equatable {
  final bool googleProgress;
  final ErrorType? error;

  const MainLoginPageState(this.googleProgress, this.error);

  MainLoginPageState copyWith({bool? googleProgress, ErrorType? error}) =>
      MainLoginPageState(googleProgress ?? this.googleProgress, error);

  @override
  List<Object?> get props => [];
}

abstract class MainLoginPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginWithGoogleEvent extends MainLoginPageEvent {}

class ClearErrorEvent extends MainLoginPageEvent {}

class MainLoginPageBloc extends Bloc<MainLoginPageEvent, MainLoginPageState> {
  final AuthRepository _authRepository;

  MainLoginPageBloc(this._authRepository) : super(const MainLoginPageState(false, null));

  @override
  Stream<MainLoginPageState> mapEventToState(MainLoginPageEvent event) async* {
    if (event is LoginWithGoogleEvent) {
      yield* _mapLoginWithGoogleEventToState();
    } else if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    }
  }

  Stream<MainLoginPageState> _mapLoginWithGoogleEventToState() async* {
    yield state.copyWith(googleProgress: true);
    try {
      await _authRepository.signInWithGoogle();
      yield state.copyWith(googleProgress: false);
    } catch (ex, st) {
      Fimber.w("Failed to log in", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          googleProgress: false);
    }
  }
}