import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/model/user_profile.dart';
import 'package:fastmarket/theme/ct_button.dart';
import 'package:fastmarket/theme/ct_snackbar.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class AdvertOwnerProfile extends StatelessWidget {
  final VoidCallback? onChat;
  final UserProfile profile;

  const AdvertOwnerProfile({this.onChat, required this.profile});

  @override
  Widget build(BuildContext context) {
    const placeholder =
        "https://firebasestorage.googleapis.com/v0/b/fast-market-48da0.appspot.com/o/appImages%2FProfile_avatar_placeholder_large.png?alt=media&token=9e8f83b6-52dd-49ff-9791-159bafd526bc";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Seller: ",
            style: AppTypography.caption2,
          ),
        ),
        const SizedBox(height: 10),
        CachedNetworkImage(
            imageUrl: profile.avatarUrl ?? placeholder,
            imageBuilder: (context, imageProvider) => Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(75),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fitWidth),
                  ),
                ),
            placeholder: (context, url) =>
                const SizedBox(width: 150, height: 150)),
        const SizedBox(height: 10),
        Text(
          "${profile.firstName} ${profile.lastName}",
          style: AppTypography.body1,
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Email: ${profile.email}", style: AppTypography.body3),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: GestureDetector(
              child: const Icon(Icons.copy),
              onTap: () {
                FlutterClipboard.copy('${profile.email}');
                ScaffoldMessenger.of(context).showSnackBar(
                    CTSnackBar(text: "Copied ${profile.email} to clipboard"));
              },
            ),
          )
        ]),
        const SizedBox(height: 10),
        CTButton("Contact user", onChat, width: 200),
        const SizedBox(height: 10),
      ],
    );
  }
}
