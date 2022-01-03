import 'package:domain/model/advertisement.dart';
import 'package:domain/model/chat_room.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/model/user_profile.dart';
import 'package:domain/repository/advertisement_repository.dart';
import 'package:domain/repository/chat_repository.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/repository/image_upload_repository.dart';

class AdvertDetailsPageState extends Equatable {
  final Advertisement advertisement;
  final UserProfile? owner;
  final ErrorType? error;
  final bool advertWasPublished;
  final bool redirectToChat;
  final ChatRoom? redirectedChatRoom;

  const AdvertDetailsPageState(this.advertisement, this.owner, this.error,
      this.advertWasPublished, this.redirectToChat, this.redirectedChatRoom);

  AdvertDetailsPageState copyWith(
          {Advertisement? advertisement,
          UserProfile? owner,
          ErrorType? error,
          bool? advertWasPublished,
          bool? redirectToChat,
          ChatRoom? redirectedChatRoom}) =>
      AdvertDetailsPageState(
          advertisement ?? this.advertisement,
          owner ?? this.owner,
          error,
          advertWasPublished ?? this.advertWasPublished,
          redirectToChat ?? this.redirectToChat,
          redirectedChatRoom ?? this.redirectedChatRoom);

  @override
  List<Object?> get props => [
        advertisement,
        owner,
        error,
        advertWasPublished,
        redirectToChat,
        redirectedChatRoom
      ];
}

abstract class AdvertDetailsPageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SetTitleEvent extends AdvertDetailsPageEvent {
  final String title;

  SetTitleEvent(this.title);

  @override
  List<Object> get props => [title];
}

class SetCategoryEvent extends AdvertDetailsPageEvent {
  final String category;

  SetCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class SetDescriptionEvent extends AdvertDetailsPageEvent {
  final String description;

  SetDescriptionEvent(this.description);

  @override
  List<Object> get props => [description];
}

class SetImagePathEvent extends AdvertDetailsPageEvent {
  final String path;

  SetImagePathEvent(this.path);

  @override
  List<Object> get props => [path];
}

class SaveEvent extends AdvertDetailsPageEvent {}

class LoadEvent extends AdvertDetailsPageEvent {
  final Advertisement advertisement;

  LoadEvent(this.advertisement);

  @override
  List<Object> get props => [advertisement];
}

class ContactSellerEvent extends AdvertDetailsPageEvent {}

class ClearErrorEvent extends AdvertDetailsPageEvent {}

class AdvertDetailsPageBloc
    extends Bloc<AdvertDetailsPageEvent, AdvertDetailsPageState> {
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;

  AdvertDetailsPageBloc(this._userRepository, this._chatRepository)
      : super(AdvertDetailsPageState(
            Advertisement(
                adId: "",
                ownerId: "",
                title: "",
                description: "",
                category: "",
                createdAt: DateTime.utc(2022, 1, 1)),
            null,
            null,
            false,
            false,
            null));

  @override
  Stream<AdvertDetailsPageState> mapEventToState(
      AdvertDetailsPageEvent event) async* {
    if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is LoadEvent) {
      yield* _mapLoadEventToState(event);
    } else if (event is ContactSellerEvent) {
      yield* _mapContactSellerEventToState();
    }
  }

  Stream<AdvertDetailsPageState> _mapLoadEventToState(LoadEvent event) async* {
    final advert = event.advertisement;
    final myProfile = _userRepository.userProfile;
    var owner = await _userRepository.getUserById(advert.ownerId);
    if (myProfile != null &&
        owner != null &&
        myProfile.userId == owner.userId) {
      owner = null;
    }
    yield state.copyWith(advertisement: advert, owner: owner);
  }

  Stream<AdvertDetailsPageState> _mapContactSellerEventToState() async* {
    final myProfile = _userRepository.userProfile;
    final ownerProfile = state.owner;
    if (myProfile != null &&
        ownerProfile != null &&
        myProfile.userId != ownerProfile.userId) {
      try {
        final chatRoom = _createChatRoom(myProfile, ownerProfile);
        await _chatRepository.createChatroom(chatRoom);
        yield state.copyWith(
            redirectToChat: true, redirectedChatRoom: chatRoom);
      } catch (ex, st) {
        Fimber.w("Couldn't create chat room", ex: ex, stacktrace: st);
      }
    }
  }

  ChatRoom _createChatRoom(UserProfile user1, UserProfile user2) {
    final first = user1.userId.compareTo(user2.userId);
    var chatRoomId;
    List<String> userIds, fullUsernames = [];
    List<String?> userAvatars = [];
    if (first == -1) {
      chatRoomId = user1.userId + '_' + user2.userId;
      userIds = [user1.userId, user2.userId];
      fullUsernames = [
        "${user1.firstName} ${user1.lastName}",
        "${user2.firstName} ${user2.lastName}"
      ];
      userAvatars = [user1.avatarUrl, user2.avatarUrl];
    } else {
      chatRoomId = user2.userId + '_' + user1.userId;
      userIds = [user2.userId, user1.userId];
      fullUsernames = [
        "${user2.firstName} ${user2.lastName}",
        "${user1.firstName} ${user1.lastName}"
      ];
      userAvatars = [user2.avatarUrl, user1.avatarUrl];
    }
    final timeNow = DateTime.now();
    final chatRoom = ChatRoom(
        chatRoomId: chatRoomId,
        participatingUserIds: userIds,
        participatingUserFullNames: fullUsernames,
        participatingUserAvatarUrls: userAvatars,
        hasMessages: false,
        lastMessageTimestamp: timeNow);
    return chatRoom;
  }
}
