import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/model/chat_room.dart';
import 'package:domain/repository/user_repository.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final ChatRoom chatRoom;
  final int notMyIndex;

  const ChatListTile({required this.onTap, required this.chatRoom, required this.notMyIndex});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM d, HH:mm');
    const placeholder =
        "https://firebasestorage.googleapis.com/v0/b/fast-market-48da0.appspot.com/o/appImages%2FProfile_avatar_placeholder_large.png?alt=media&token=9e8f83b6-52dd-49ff-9791-159bafd526bc";

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greyDropShadow,
          borderRadius: BorderRadius.circular(5)
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CachedNetworkImage(
                imageUrl: chatRoom.participatingUserAvatarUrls[notMyIndex] ?? placeholder,
                imageBuilder: (context, imageProvider) => Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(35),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fitWidth),
                  ),
                ),
                placeholder: (context, url) =>
                const SizedBox(width: 70, height: 70)),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatRoom.participatingUserFullNames[notMyIndex],
                      style: AppTypography.headline4.copyWith(color: AppColors.textBlue),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${chatRoom.lastMessage}",
                      style: AppTypography.caption2.copyWith(color: AppColors.disabledShadow),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${formatter.format(chatRoom.lastMessageTimestamp!)}",
                      style: AppTypography.caption2.copyWith(color: AppColors.disabledShadow),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
