import 'package:domain/model/error_type.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailLoginPageState extends Equatable {
  final bool progress;
  final ErrorType? error;
  final String email;
  final String password;

  EmailLoginPageState(this.progress, this.error,
      {required this.email, required this.password});

  EmailLoginPageState copyWith(
      {bool? progress,
        ErrorType? error,
        String? email,
        String? password}) =>
      EmailLoginPageState(progress ?? this.progress, error,
          email: email ?? this.email, password: password ?? this.password);

  bool isButtonEnabled() =>
      email.isNotEmpty == true && password.isNotEmpty == true;

  @override
  List<Object?> get props => [progress, error, email, password];
}

abstract class EmailLoginPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ClearErrorEvent extends EmailLoginPageEvent {}

class SetEmailEvent extends EmailLoginPageEvent {
  final String email;

  SetEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}

class SetPasswordEvent extends EmailLoginPageEvent {
  final String password;

  SetPasswordEvent(this.password);

  @override
  List<Object> get props => [password];
}

class LoginEvent extends EmailLoginPageEvent {}

class EmailLoginPageBloc
    extends Bloc<EmailLoginPageEvent, EmailLoginPageState> {
  final AuthRepository _authRepository;

  EmailLoginPageBloc(this._authRepository)
      : super(EmailLoginPageState(false, null, email: '', password: ''));

  @override
  Stream<EmailLoginPageState> mapEventToState(
      EmailLoginPageEvent event) async* {
    if (event is SetEmailEvent) {
      yield state.copyWith(email: event.email);
    } else if (event is SetPasswordEvent) {
      yield state.copyWith(password: event.password);
    } else if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is LoginEvent) {
      yield* _mapLoginEventToState();
    }
  }

  Stream<EmailLoginPageState> _mapLoginEventToState() async* {
    yield state.copyWith(progress: true);
    try {
      await _authRepository.login(state.email, state.password);
      yield state.copyWith(progress: false);
      print("logged in");
    } catch (ex, st) {
      Fimber.w("Failed to log in", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false);
    }
  }
}
