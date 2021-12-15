import 'dart:math';

import 'package:fastmarket/profile/profile_add_avatar_popup.dart';
import 'package:fastmarket/profile/profile_page_bloc.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_loading_button.dart';
import 'package:fastmarket/theme/icons_provider.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();

  static Widget withBloc() => BlocProvider<ProfilePageBloc>(
      child: ProfilePage(),
      create: (context) =>
          ProfilePageBloc(context.read(), context.read(), context.read())..add(LoadEvent()));
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfilePageBloc _bloc;

  @override
  void initState() {
    _bloc = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePageBloc, ProfilePageState>(
        builder: (context, state) => _buildBody(state));
  }

  Widget _buildBody(ProfilePageState state) => Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 42),
                child: Column(
                  children: [
                    AvatarImage(
                      avatarUrl: state.avatarUrl,
                      showEdit: true,
                      onEdit: () async {
                        ProfileAvatarPopup.showPhotoOptions(context, (url, filename) {
                            _bloc.add(ChangeProfileUrlEvent(url, filename));
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Text("You are currently logged in as",
                        style: AppTypography.headline4
                            .copyWith(color: AppColors.disabled2)),
                    const SizedBox(height: 12),
                    Text(
                        "${state.userProfile.firstName} ${state.userProfile.lastName}",
                        style: AppTypography.headline3
                            .copyWith(color: AppColors.textBlue)),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 24, top: 16),
                      child: CTLoadingButton(
                        "Log Out",
                        () {
                          _bloc.add(LogoutEvent());
                        },
                        icon: IconsProvider.LOGOUT,
                        color: AppColors.patternBlue,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      );
}

class AvatarImage extends StatelessWidget {
  final String? avatarUrl;
  final bool showEdit;
  final VoidCallback onEdit;

  const AvatarImage(
      {required this.avatarUrl, required this.showEdit, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipOval(
        child: FadeInImage.memoryNetwork(
          fadeInDuration: const Duration(milliseconds: 500),
          fadeOutDuration: const Duration(milliseconds: 500),
          width: 150,
          height: 150,
          placeholder: kTransparentImage,
          image: avatarUrl ??
              "https://firebasestorage.googleapis.com/v0/b/fast-market-48da0.appspot.com/o/appImages%2FProfile_avatar_placeholder_large.png?alt=media&token=9e8f83b6-52dd-49ff-9791-159bafd526bc",
        ),
      ),
      if (showEdit)
        Positioned(
            bottom: 3,
            right: 9,
            child: GestureDetector(
              onTap: onEdit,
              child: CircleAvatar(
                backgroundColor: AppColors.white,
                radius: 20,
                child: CircleAvatar(
                  backgroundColor:
                      AppColors.purpleItemBackground.withOpacity(0.5),
                  radius: 18,
                  child: SvgPicture.asset(IconsProvider.OPTION_EDIT,
                      color: AppColors.textBlue, width: 24, height: 24),
                ),
              ),
            ))
    ]);
  }
}
