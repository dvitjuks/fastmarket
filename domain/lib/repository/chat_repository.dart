import 'package:domain/model/chat_message.dart';
import 'package:domain/model/chat_room.dart';

abstract class ChatRepository {
  Future<void> addMessageToChatroom(ChatMessage message, String chatroomId);

  Future<void> createChatroom(ChatRoom chatRoom);

  Future<Stream<List<ChatRoom>>> getChatrooms();

  Future<Stream<List<ChatMessage>>> getMessages(String chatRoomId);

  Future<void> updateAllAvatarsInChats(String url);
}
