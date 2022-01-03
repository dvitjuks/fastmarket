import 'package:domain/model/chat_room.dart';
import 'package:domain/model/error_type.dart';
import 'package:domain/repository/chat_repository.dart';
import 'package:domain/model/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseChatRepository implements ChatRepository {
  final chatRoomsRef = FirebaseFirestore.instance
      .collection("chatRooms")
      .withConverter<ChatRoom>(
          fromFirestore: (snapshot, _) => ChatRoom.fromJson(snapshot.data()!),
          toFirestore: (chatRoom, _) => chatRoom.toJson());

  @override
  Future<void> addMessageToChatroom(
      ChatMessage message, String chatroomId) async {
    try {
      await chatRoomsRef
          .doc(chatroomId)
          .collection("messages")
          .doc(message.messageId)
          .set(message.toJson());

      await chatRoomsRef.doc(chatroomId).update({
        "lastMessage": message.messageText,
        "lastMessageTimestamp": message.sentAt.toIso8601String(),
        "hasMessages": true
      });
    } catch (ex, st) {
      Fimber.w("Couldn't send chat message", ex: ex, stacktrace: st);
      throw AppError(ErrorType.generalError);
    }
  }

  @override
  Future<void> createChatroom(ChatRoom chatRoom) async {
    final chatRoomExists = await chatRoomsRef
        .doc(chatRoom.chatRoomId)
        .get()
        .then((value) => value.exists);

    if (chatRoomExists) {
      return;
    } else {
      try {
        await chatRoomsRef.doc(chatRoom.chatRoomId).set(chatRoom);
      } catch (ex, st) {
        Fimber.w("Couldn't create chat room", ex: ex, stacktrace: st);
        throw AppError(ErrorType.generalError);
      }
    }
  }

  @override
  Future<Stream<List<ChatRoom>>> getChatrooms() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      var query =
          chatRoomsRef.where("participatingUserIds", arrayContains: uid);
      query = query.where("hasMessages", isEqualTo: true);
      query = query.orderBy("lastMessageTimestamp", descending: true);
      return query.snapshots().map((snapshot) =>
          snapshot.docs.map((element) => element.data()).toList());
    } else {
      Fimber.w("You are unauthorized, please authorize to load your chatrooms");
      return const Stream.empty();
    }
  }

  @override
  Future<Stream<List<ChatMessage>>> getMessages(String chatRoomId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final messagesRef = chatRoomsRef
          .doc(chatRoomId)
          .collection("messages")
          .withConverter<ChatMessage>(
              fromFirestore: (snapshot, _) =>
                  ChatMessage.fromJson(snapshot.data()!),
              toFirestore: (chatMessage, _) => chatMessage.toJson());

      var query = messagesRef.orderBy("sentAt", descending: true);

      return query.snapshots().map((snapshot) =>
          snapshot.docs.map((element) => element.data()).toList());
    } else {
      Fimber.w(
          "You are unauthorized, please authorize to load messages of this chatroom");
      return const Stream.empty();
    }
  }

  @override
  Future<void> updateAllAvatarsInChats(String url) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final myChatRooms = await chatRoomsRef
          .where("participatingUserIds", arrayContains: userId)
          .get()
          .then((value) => value.docs.map((e) => e.data()).toList());

      if (myChatRooms.isNotEmpty) {
        for (var chatRoom in myChatRooms) {
          final indexToReplace =
              chatRoom.participatingUserIds[0] == userId ? 0 : 1;
          var array = chatRoom.participatingUserAvatarUrls;
          array[indexToReplace] = url;
          chatRoomsRef
              .doc(chatRoom.chatRoomId)
              .update({"participatingUserAvatarUrls": array});
        }
      }
    }
  }
}
