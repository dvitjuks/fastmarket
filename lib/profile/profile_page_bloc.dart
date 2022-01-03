import 'package:domain/model/error_type.dart';
import 'package:domain/model/user_profile.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:domain/repository/chat_repository.dart';
import 'package:domain/repository/image_upload_repository.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageState extends Equatable {
  final bool progress;
  final UserProfile userProfile;
  final String? avatarUrl;
  final ErrorType? error;

  const ProfilePageState(
      this.progress, this.userProfile, this.avatarUrl, this.error);

  ProfilePageState copyWith(
          {bool? progress,
          UserProfile? userProfile,
          String? avatarUrl,
          ErrorType? error}) =>
      ProfilePageState(progress ?? this.progress,
          userProfile ?? this.userProfile, avatarUrl ?? this.avatarUrl, error);

  @override
  List<Object?> get props => [progress, userProfile, avatarUrl, error];
}

abstract class ProfilePageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends ProfilePageEvent {}

class ChangeProfileUrlEvent extends ProfilePageEvent {
  final String url;
  final String filename;

  ChangeProfileUrlEvent(this.url, this.filename);

  @override
  List<Object> get props => [url, filename];
}

class ClearErrorEvent extends ProfilePageEvent {}

class LogoutEvent extends ProfilePageEvent {}

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final ImageUploadRepository _userAvatarRepository;
  final ChatRepository _chatRepository;

  ProfilePageBloc(this._authRepository, this._userRepository,
      this._userAvatarRepository, this._chatRepository)
      : super(
            ProfilePageState(false, const UserProfile(userId: ""), null, null));

  @override
  Stream<ProfilePageState> mapEventToState(ProfilePageEvent event) async* {
    if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is LogoutEvent) {
      yield* _mapLogoutEventToState();
    } else if (event is LoadEvent) {
      yield* _mapLoadEventToState();
    } else if (event is ChangeProfileUrlEvent) {
      yield* _mapChangeProfileUrlEventToState(event);
    }
  }

  Stream<ProfilePageState> _mapLoadEventToState() async* {
    try {
      final user = await _userRepository.loadUser(true);
      yield state.copyWith(userProfile: user, avatarUrl: user.avatarUrl);
    } catch (ex, st) {
      Fimber.w("Failed to log out", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError));
    }
  }

  Stream<ProfilePageState> _mapLogoutEventToState() async* {
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

  Stream<ProfilePageState> _mapChangeProfileUrlEventToState(
      ChangeProfileUrlEvent event) async* {
    try {
      final url = event.url;
      final filename = event.filename;
      final currentFilename = state.userProfile.avatarFilename;
      if (currentFilename != null) {
        await _userAvatarRepository.deleteAvatar(currentFilename);
      }
      final updatedUser =
          state.userProfile.copyWith(avatarUrl: url, avatarFilename: filename);
      _userRepository.saveUser(updatedUser);
      _chatRepository.updateAllAvatarsInChats(url);
      yield state.copyWith(avatarUrl: url, userProfile: updatedUser);
    } catch (ex, st) {
      Fimber.w("Failed to save user avatar url", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: ex is AppError ? ex.type : ErrorType.generalError);
    }
  }
}
