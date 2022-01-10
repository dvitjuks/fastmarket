import 'package:domain/model/advertisement.dart';
import 'package:domain/model/chat_room.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/model/user_profile.dart';
import 'package:domain/repository/advertisement_repository.dart';
import 'package:domain/repository/chat_repository.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvertDetailsPageState extends Equatable {
  final Advertisement advertisement;
  final UserProfile? owner;
  final ErrorType? error;
  final bool advertWasPublished;
  final bool redirectToChat;
  final bool editModeOn;
  final ChatRoom? redirectedChatRoom;
  final bool saving;

  const AdvertDetailsPageState(this.advertisement,
      this.owner,
      this.error,
      this.advertWasPublished,
      this.redirectToChat,
      this.editModeOn,
      this.redirectedChatRoom,
      this.saving);

  AdvertDetailsPageState copyWith({Advertisement? advertisement,
    UserProfile? owner,
    ErrorType? error,
    bool? advertWasPublished,
    bool? redirectToChat,
    bool? editModeOn,
    ChatRoom? redirectedChatRoom,
    bool? saving}) =>
      AdvertDetailsPageState(
          advertisement ?? this.advertisement,
          owner ?? this.owner,
          error,
          advertWasPublished ?? this.advertWasPublished,
          redirectToChat ?? this.redirectToChat,
          editModeOn ?? this.editModeOn,
          redirectedChatRoom ?? this.redirectedChatRoom,
          saving ?? this.saving);

  @override
  List<Object?> get props =>
      [
        advertisement,
        owner,
        error,
        advertWasPublished,
        redirectToChat,
        editModeOn,
        redirectedChatRoom,
        saving
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

class EnterEditModeEvent extends AdvertDetailsPageEvent {}

class AdvertDetailsPageBloc
    extends Bloc<AdvertDetailsPageEvent, AdvertDetailsPageState> {
  final UserRepository _userRepository;
  final ChatRepository _chatRepository;
  final AdvertisementRepository _advertisementRepository;

  AdvertDetailsPageBloc(this._userRepository, this._chatRepository,
      this._advertisementRepository)
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
      false,
      null,
      false));

  @override
  Stream<AdvertDetailsPageState> mapEventToState(
      AdvertDetailsPageEvent event) async* {
    if (event is ClearErrorEvent) {
      yield state.copyWith(error: null);
    } else if (event is LoadEvent) {
      yield* _mapLoadEventToState(event);
    } else if (event is ContactSellerEvent) {
      yield* _mapContactSellerEventToState();
    } else if (event is EnterEditModeEvent) {
      yield state.copyWith(editModeOn: true);
    } else if (event is SaveEvent) {
      yield* _mapSaveEventToState();
    } else if (event is SetTitleEvent) {
      yield state.copyWith(
          advertisement: state.advertisement.copyWith(title: event.title));
    } else if (event is SetCategoryEvent) {
      yield state.copyWith(advertisement: state.advertisement.copyWith(
          category: event.category));
    } else if (event is SetDescriptionEvent) {
      yield state.copyWith(advertisement: state.advertisement.copyWith(
          description: event.description));
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

  Stream<AdvertDetailsPageState> _mapSaveEventToState() async* {
    yield state.copyWith(saving: true, editModeOn: false);
    try {
      final advert = state.advertisement;
      await _advertisementRepository.saveAdvertisement(advert);
      yield state.copyWith(saving: false);
    } catch (ex, st) {
      Fimber.w("Couldn't save advertisement", ex: ex, stacktrace: st);
      yield state.copyWith(error: ErrorType.generalError, saving: false);
    }
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
    List<String> userIds,
        fullUsernames = [];
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
