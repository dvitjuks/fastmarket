// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      chatRoomId: json['chatRoomId'] as String,
      participatingUserIds: (json['participatingUserIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participatingUserFullNames:
          (json['participatingUserFullNames'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      participatingUserAvatarUrls:
          (json['participatingUserAvatarUrls'] as List<dynamic>)
              .map((e) => e as String?)
              .toList(),
      hasMessages: json['hasMessages'] as bool,
      lastMessage: json['lastMessage'] as String?,
      lastMessageTimestamp: json['lastMessageTimestamp'] == null
          ? null
          : DateTime.parse(json['lastMessageTimestamp'] as String),
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'chatRoomId': instance.chatRoomId,
      'participatingUserIds': instance.participatingUserIds,
      'participatingUserFullNames': instance.participatingUserFullNames,
      'participatingUserAvatarUrls': instance.participatingUserAvatarUrls,
      'hasMessages': instance.hasMessages,
      'lastMessage': instance.lastMessage,
      'lastMessageTimestamp': instance.lastMessageTimestamp?.toIso8601String(),
    };
