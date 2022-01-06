import 'package:domain/model/chat_room.dart';
import 'package:fastmarket/chats/all_chats_screen_bloc.dart';
import 'package:fastmarket/chats/chat_list_tile.dart';
import 'package:fastmarket/chats/chatroom_screen.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllChatsPage extends StatefulWidget {
  @override
  _AllChatsPageState createState() => _AllChatsPageState();

  static Widget withBloc() => BlocProvider(
      create: (context) =>
          AllChatsPageBloc(context.read(), context.read())..add(LoadEvent()),
      child: AllChatsPage());
}

class _AllChatsPageState extends State<AllChatsPage> {
  late AllChatsPageBloc _bloc;

  @override
  void initState() {
    _bloc = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllChatsPageBloc, AllChatsPageState>(
        builder: (context, state) {
      return _buildBody(state);
    });
  }

  Widget _buildChatrooms(AllChatsPageState state) {
    return Column(
      children: [
        StreamBuilder(
            stream: state.allChatrooms,
            builder: (context, AsyncSnapshot<List<ChatRoom>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final data = snapshot.data!;
                return Expanded(
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          final chatroom = data[index];
                          int? notMyIndex;
                          notMyIndex =
                              (chatroom.participatingUserIds[0] == state.myUid)
                                  ? 1
                                  : 0;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ChatListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ChatroomScreen.withBloc(chatroom)));
                                },
                                chatRoom: chatroom,
                                notMyIndex: notMyIndex),
                          );
                        },
                        itemCount: data.length));
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        Text("You didn't start any chats yet",
                            style: AppTypography.title),
                      ],
                    ),
                  ),
                );
              }
            })
      ],
    );
  }

  Widget _buildBody(AllChatsPageState state) => Scaffold(
      appBar: AppBar(
        title: Text("Chats",
            style: AppTypography.app_bar.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.patternBlue,
        shadowColor: AppColors.transparent,
      ),
      body: Container(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: _buildChatrooms(state)));
}
