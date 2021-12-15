import 'package:domain/model/error_type.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailSignUpPageState extends Equatable {
  final bool progress;
  final ErrorType? error;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool registered;
  final bool finished;

  EmailSignUpPageState(
      {this.progress = false,
        this.error,
        required this.email,
        required this.password,
        required this.firstName,
        required this.lastName,
        required this.registered,
        required this.finished});

  EmailSignUpPageState copyWith(
      {bool? progress,
        ErrorType? error,
        String? email,
        String? password,
        String? firstName,
        String? lastName,
        bool? registered,
        bool? finished}) =>
      EmailSignUpPageState(
          progress: progress ?? this.progress,
          error: error,
          email: email ?? this.email,
          password: password ?? this.password,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          registered: registered ?? this.registered,
          finished: finished ?? this.finished);

  bool isRegisterEnabled() =>
      email.isNotEmpty == true &&
          password.isNotEmpty == true &&
          EmailValidator.validate(email);

  bool isFinishEnabled() =>
      firstName.isNotEmpty == true && lastName.isNotEmpty == true;

  @override
  List<Object?> get props => [
    progress,
    error,
    email,
    password,
    firstName,
    lastName,
    type,
    registered,
    finished
  ];
}

abstract class EmailSignUpPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ClearRegisteredEvent extends EmailSignUpPageEvent {}

class ClearErrorEvent extends EmailSignUpPageEvent {}

class SetEmailEvent extends EmailSignUpPageEvent {
  final String email;

  SetEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}

class SetPasswordEvent extends EmailSignUpPageEvent {
  final String password;

  SetPasswordEvent(this.password);

  @override
  List<Object> get props => [password];
}

class SetFirstNameEvent extends EmailSignUpPageEvent {
  final String firstName;

  SetFirstNameEvent(this.firstName);

  @override
  List<Object> get props => [firstName];
}

class SetLastNameEvent extends EmailSignUpPageEvent {
  final String lastName;

  SetLastNameEvent(this.lastName);

  @override
  List<Object> get props => [lastName];
}

class RegisterEvent extends EmailSignUpPageEvent {}

class CreateUserEvent extends EmailSignUpPageEvent {}

class EmailSignUpPageBloc extends Bloc<EmailSignUpPageEvent, EmailSignUpPageState> {
  final AuthRepository _authRepository;

  EmailSignUpPageBloc(this._authRepository)
      : super(EmailSignUpPageState(
      progress: false,
      finished: false,
      registered: false,
      password: '',
      email: '',
      lastName: '',
      firstName: ''));

  @override
  Stream<EmailSignUpPageState> mapEventToState(EmailSignUpPageEvent event) async* {
    if (event is SetEmailEvent) {
      yield state.copyWith(email: event.email);
    } else if (event is SetPasswordEvent) {
      yield state.copyWith(password: event.password);
    } else if (event is SetFirstNameEvent) {
      yield state.copyWith(firstName: event.firstName);
    } else if (event is SetLastNameEvent) {
      yield state.copyWith(lastName: event.lastName);
    } else if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is ClearRegisteredEvent) {
      yield state.copyWith(registered: false);
    } else if (event is RegisterEvent) {
      yield* _mapRegisterEventToState();
    } else if (event is CreateUserEvent) {
      yield* _mapCreateUserEventToState();
    }
  }

  Stream<EmailSignUpPageState> _mapRegisterEventToState() async* {
    yield state.copyWith(progress: true);
    try {
      await _authRepository.signUp(state.email, state.password);
      yield state.copyWith(progress: false, registered: true);
    } catch (ex, st) {
      Fimber.w("Failed to sign up", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false);
    }
  }

  Stream<EmailSignUpPageState> _mapCreateUserEventToState() async* {
    yield state.copyWith(progress: true);
    try {
      if (state.lastName.isNotEmpty && state.firstName.isNotEmpty) {
        await _authRepository.createProfile(
            state.firstName, state.lastName, null);
        yield state.copyWith(progress: false, finished: true);
      }
    } catch (ex, st) {
      Fimber.w("Failed to create user profile", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false);
    }
  }
}
