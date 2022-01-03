import 'package:domain/model/chat_message.dart';
import 'package:domain/model/chat_room.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/model/user_profile.dart';
import 'package:domain/repository/chat_repository.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatroomScreenState extends Equatable {
  final bool progress;
  final String chatRoomId;
  final UserProfile contact;
  final String myId;
  final Stream<List<ChatMessage>> allMessages;
  final ErrorType? error;

  const ChatroomScreenState(this.progress, this.chatRoomId, this.contact,
      this.myId, this.allMessages, this.error);

  ChatroomScreenState copyWith(
          {bool? progress,
          String? chatRoomId,
          UserProfile? contact,
          String? myId,
          Stream<List<ChatMessage>>? allMessages,
          ErrorType? error}) =>
      ChatroomScreenState(
          progress ?? this.progress,
          chatRoomId ?? this.chatRoomId,
          contact ?? this.contact,
          myId ?? this.myId,
          allMessages ?? this.allMessages,
          error);

  @override
  List<Object?> get props =>
      [progress, chatRoomId, myId, contact, allMessages, error];
}

abstract class ChatroomScreenEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends ChatroomScreenEvent {
  final ChatRoom chatRoom;

  LoadEvent(this.chatRoom);

  @override
  List<Object> get props => [chatRoom];
}

class SendMessageEvent extends ChatroomScreenEvent {
  final String text;

  SendMessageEvent(this.text);

  @override
  List<Object> get props => [text];
}

class ClearErrorEvent extends ChatroomScreenEvent {}

class ChatroomScreenBloc
    extends Bloc<ChatroomScreenEvent, ChatroomScreenState> {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;

  ChatroomScreenBloc(this._chatRepository, this._userRepository)
      : super(ChatroomScreenState(
            false, "", UserProfile(userId: ''), "", Stream.empty(), null));

  @override
  Stream<ChatroomScreenState> mapEventToState(
      ChatroomScreenEvent event) async* {
    if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is LoadEvent) {
      yield* _mapLoadEventToState(event);
    } else if (event is SendMessageEvent) {
      yield* _mapSendMessageEventToState(event);
    }
  }

  Stream<ChatroomScreenState> _mapLoadEventToState(LoadEvent event) async* {
    yield state.copyWith(progress: true);
    try {
      final chatRoom = event.chatRoom;
      final myProfile = await _userRepository.loadUser(false);
      String contactId;
      if (chatRoom.participatingUserIds[0] == myProfile.userId) {
        contactId = chatRoom.participatingUserIds[1];
      } else {
        contactId = chatRoom.participatingUserIds[0];
      }
      final contact = await _userRepository.getUserById(contactId);
      var chatMessages = await _chatRepository.getMessages(chatRoom.chatRoomId);
      yield state.copyWith(
          progress: false,
          chatRoomId: chatRoom.chatRoomId,
          allMessages: chatMessages,
          contact: contact,
          myId: myProfile.userId);
    } catch (ex, st) {
      Fimber.w("Failed to load chat rooms", ex: ex, stacktrace: st);
      yield state.copyWith(
          error: (ex is AppError ? ex.type : ErrorType.generalError),
          progress: false);
    }
  }

  Stream<ChatroomScreenState> _mapSendMessageEventToState(
      SendMessageEvent event) async* {
    try {
      final timeNow = DateTime.now();
      final id = generateMessageId(state.myId, state.contact.userId, timeNow);
      final message = ChatMessage(
          messageId: id,
          messageText: event.text,
          senderId: state.myId,
          sentAt: timeNow);
      await _chatRepository.addMessageToChatroom(message, state.chatRoomId);
    } catch (ex, st) {
      Fimber.w("Couldn't send message", ex: ex, stacktrace: st);
    }
  }

  String generateMessageId(String userId, String contactId, DateTime timeNow) {
    final id = userId + '_to_' + contactId + '_at_' + timeNow.toIso8601String();
    return id;
  }
}
