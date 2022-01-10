import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedNetworkAvatar extends StatelessWidget {
  final double width;
  final double height;
  final String? imageUrl;

  const CachedNetworkAvatar(
      {Key? key,
      required this.width,
      required this.height,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const placeholder =
        "https://firebasestorage.googleapis.com/v0/b/fast-market-48da0.appspot.com/o/appImages%2FProfile_avatar_placeholder_large.png?alt=media&token=9e8f83b6-52dd-49ff-9791-159bafd526bc";
    return CachedNetworkImage(
        imageUrl: imageUrl ?? placeholder,
        imageBuilder: (context, imageProvider) => Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(min(width, height) / 2),
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.fitWidth),
              ),
            ),
        placeholder: (context, url) => SizedBox(width: width, height: height));
  }
}
