import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room.g.dart';

@JsonSerializable()
class ChatRoom extends Equatable {
  final String chatRoomId;
  final List<String> participatingUserIds;
  final List<String> participatingUserFullNames;
  final List<String?> participatingUserAvatarUrls;
  final bool hasMessages;
  final String? lastMessage;
  final DateTime? lastMessageTimestamp;

  const ChatRoom(
      {required this.chatRoomId,
      required this.participatingUserIds,
      required this.participatingUserFullNames,
      required this.participatingUserAvatarUrls,
      required this.hasMessages,
      this.lastMessage,
      this.lastMessageTimestamp});

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);

  @override
  List<Object?> get props => [
        chatRoomId,
        participatingUserIds,
        participatingUserFullNames,
        participatingUserAvatarUrls,
        hasMessages,
        lastMessage,
        lastMessageTimestamp
      ];
}
