import 'package:domain/model/chat_message.dart';
import 'package:domain/model/chat_room.dart';
import 'package:fastmarket/chats/cached_network_avatar.dart';
import 'package:fastmarket/chats/chatroom_screen_bloc.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_back_button.dart';
import 'package:fastmarket/theme/ct_text_form_field.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatroomScreen extends StatefulWidget {
  @override
  _ChatroomScreenState createState() => _ChatroomScreenState();

  static Widget withBloc(ChatRoom chatRoom) => BlocProvider(
        create: (context) => ChatroomScreenBloc(context.read(), context.read())
          ..add(LoadEvent(chatRoom)),
        child: ChatroomScreen(),
      );
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  final formController = TextEditingController();
  late ChatroomScreenBloc _bloc;

  @override
  void initState() {
    _bloc = context.read();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    formController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatroomScreenBloc, ChatroomScreenState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          shadowColor: Colors.transparent,
          leading: CTBackButton(AppColors.textBlue, AppColors.textBlack),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkAvatar(
                  width: 36, height: 36, imageUrl: state.contact.avatarUrl),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                    "${state.contact.firstName} ${state.contact.lastName}",
                    style: AppTypography.app_bar
                        .copyWith(color: AppColors.textBlue)),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              StreamBuilder(
                  stream: state.allMessages,
                  builder:
                      (context, AsyncSnapshot<List<ChatMessage>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final data = snapshot.data!;
                      return Container(
                          color: AppColors.borderGrey.withOpacity(0.5),
                          padding: const EdgeInsets.only(bottom: 80),
                          child: ListView.builder(
                            reverse: true,
                            itemBuilder: (context, index) {
                              final message = data[index];
                              final isMine = message.senderId == state.myId;
                              return chatMessageTile(
                                  message.messageText, isMine);
                            },
                            itemCount: data.length,
                          ));
                    } else {
                      return Container(
                        color: AppColors.borderGrey.withOpacity(0.5),
                      );
                    }
                  }),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    border: Border(
                      top: BorderSide(
                          width: 1.0, color: AppColors.disabledShadow),
                      left: BorderSide(
                          width: 1.0, color: AppColors.disabledShadow),
                      right: BorderSide(
                          width: 1.0, color: AppColors.disabledShadow),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: CTTextFormField(
                        (text) => {},
                        controller: formController,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: GestureDetector(
                          child: const Icon(
                            Icons.send,
                            color: AppColors.textBlue,
                          ),
                          onTap: () {
                            final text = formController.value.text;
                            if (text.isNotEmpty) {
                              _bloc.add(
                                  SendMessageEvent(formController.value.text));
                              formController.text = "";
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Padding(
      padding: EdgeInsets.only(
          left: sendByMe ? 24 : 0, right: sendByMe ? 0 : 24, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment:
            sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(24),
                    bottomRight: sendByMe
                        ? const Radius.circular(0)
                        : const Radius.circular(24),
                    topRight: const Radius.circular(24),
                    bottomLeft: sendByMe
                        ? const Radius.circular(24)
                        : const Radius.circular(0),
                  ),
                  color: sendByMe
                      ? AppColors.patternBlue
                      : AppColors.greyDropShadow,
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  message,
                  style: AppTypography.body2.copyWith(
                      color: sendByMe ? AppColors.white : AppColors.textBlue),
                )),
          ),
        ],
      ),
    );
  }
}
