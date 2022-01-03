import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage extends Equatable {
  final String messageId;
  final String messageText;
  final String senderId;
  final DateTime sentAt;

  const ChatMessage(
      {required this.messageId,
      required this.messageText,
      required this.senderId,
      required this.sentAt});

  ChatMessage copyWith(
          {String? messageId,
          String? messageText,
          String? senderId,
          DateTime? sentAt}) =>
      ChatMessage(
          messageId: messageId ?? this.messageId,
          messageText: messageText ?? this.messageText,
          senderId: senderId ?? this.senderId,
          sentAt: sentAt ?? this.sentAt);

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  @override
  List<Object?> get props => [messageId, messageText, senderId, sentAt];
}
