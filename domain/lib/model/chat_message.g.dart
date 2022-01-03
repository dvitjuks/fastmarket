// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      messageId: json['messageId'] as String,
      messageText: json['messageText'] as String,
      senderId: json['senderId'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'messageText': instance.messageText,
      'senderId': instance.senderId,
      'sentAt': instance.sentAt.toIso8601String(),
    };
