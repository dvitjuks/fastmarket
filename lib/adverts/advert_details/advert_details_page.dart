import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/model/advertisement.dart';
import 'package:fastmarket/adverts/advert_details/owner_profile_block.dart';
import 'package:fastmarket/chats/chatroom_screen.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_back_button.dart';
import 'package:fastmarket/theme/ct_text_form_field.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'advert_details_page_bloc.dart';

class AdvertDetailsPage extends StatefulWidget {
  final Advertisement advert;

  AdvertDetailsPage({required this.advert});

  @override
  _AdvertDetailsPageState createState() => _AdvertDetailsPageState();

  static Widget withBloc(Advertisement advertisement) =>
      BlocProvider<AdvertDetailsPageBloc>(
        create: (context) =>
            AdvertDetailsPageBloc(context.read(), context.read())
              ..add(LoadEvent(advertisement)),
        child: AdvertDetailsPage(advert: advertisement),
      );
}

class _AdvertDetailsPageState extends State<AdvertDetailsPage> {
  late AdvertDetailsPageBloc _bloc;

  @override
  void initState() {
    _bloc = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const placeholder =
        "https://media.istockphoto.com/vectors/thumbnail-image-vector-graphic-vector-id1147544807?k=20&m=1147544807&s=612x612&w=0&h=pBhz1dkwsCMq37Udtp9sfxbjaMl27JUapoyYpQm0anc=";

    return BlocConsumer<AdvertDetailsPageBloc, AdvertDetailsPageState>(
        listener: (context, state) {
          if (state.redirectToChat == true &&
              state.redirectedChatRoom != null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ChatroomScreen.withBloc(state.redirectedChatRoom!)));
          }
        },
        builder: (context, state) => GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.white,
                  shadowColor: Colors.transparent,
                  leading:
                      CTBackButton(AppColors.textBlue, AppColors.textBlack),
                  centerTitle: true,
                  title: Text("Advertisement details",
                      style: AppTypography.app_bar
                          .copyWith(color: AppColors.textBlue)),
                ),
                body: CustomScrollView(
                  scrollBehavior: const MaterialScrollBehavior(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                  imageUrl: state.advertisement.imageUrl ??
                                      placeholder,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: 300.0,
                                        height: 300.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ),
                                  placeholder: (context, url) =>
                                      const SizedBox(width: 300, height: 300)),
                            ),
                            const SizedBox(height: 32),
                            const Text("Advertisement title:",
                                style: AppTypography.caption1),
                            const SizedBox(height: 4),
                            CTTextFormField((text) => {},
                                initialValue: widget.advert.title,
                                readOnly: true),
                            const SizedBox(height: 32),
                            const Text("Category:",
                                style: AppTypography.caption1),
                            const SizedBox(height: 4),
                            CTTextFormField((text) => {},
                                initialValue: widget.advert.category,
                                readOnly: true),
                            const SizedBox(height: 32),
                            const Text("Description:",
                                style: AppTypography.caption1),
                            const SizedBox(height: 4),
                            CTTextFormField((text) => {},
                                isMultiline: true,
                                readOnly: true,
                                initialValue: widget.advert.description),
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      ),
                    ),
                    if (state.owner != null)
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AdvertOwnerProfile(
                          profile: state.owner!,
                          onChat: () {
                            _bloc.add(ContactSellerEvent());
                          },
                        ),
                      ))
                  ],
                ),
              ),
            ));
  }
}
