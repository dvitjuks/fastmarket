import 'package:domain/model/chat_room.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/repository/chat_repository.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllChatsPageState extends Equatable {
  final bool progress;
  final String myUid;
  final bool loadingNewData;
  final Stream<List<ChatRoom>> allChatrooms;
  final ErrorType? error;

  const AllChatsPageState(this.progress, this.myUid, this.loadingNewData,
      this.allChatrooms, this.error);

  AllChatsPageState copyWith(
          {bool? progress,
          String? myUid,
          bool? loadingNewData,
          Stream<List<ChatRoom>>? allChatrooms,
          ErrorType? error}) =>
      AllChatsPageState(
          progress ?? this.progress,
          myUid ?? this.myUid,
          loadingNewData ?? this.loadingNewData,
          allChatrooms ?? this.allChatrooms,
          error);

  @override
  List<Object?> get props =>
      [progress, myUid, loadingNewData, allChatrooms, error];
}

abstract class AllChatsPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends AllChatsPageEvent {}

class ClearErrorEvent extends AllChatsPageEvent {}

class AllChatsPageBloc extends Bloc<AllChatsPageEvent, AllChatsPageState> {
  final ChatRepository _chatRepository;
  final UserRepository userRepository;

  AllChatsPageBloc(this._chatRepository, this.userRepository)
      : super(AllChatsPageState(false, "", false, Stream.empty(), null));

  @override
  Stream<AllChatsPageState> mapEventToState(AllChatsPageEvent event) async* {
    if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is LoadEvent) {
      yield* _mapLoadEventToState();
    }
  }

  Stream<AllChatsPageState> _mapLoadEventToState() async* {
    yield state.copyWith(progress: true);
    try {
      final myProfile = await userRepository.loadUser(false);
      var chatRooms = await _chatRepository.getChatrooms();
      yield state.copyWith(
          progress: false,
          loadingNewData: false,
          allChatrooms: chatRooms,
          myUid: myProfile.userId);
    } catch (ex, st) {
      Fimber.w("Failed to load chat rooms", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false);
    }
  }
}
