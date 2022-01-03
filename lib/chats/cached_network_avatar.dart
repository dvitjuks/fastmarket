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
        "https://media.istockphoto.com/vectors/thumbnail-image-vector-graphic-vector-id1147544807?k=20&m=1147544807&s=612x612&w=0&h=pBhz1dkwsCMq37Udtp9sfxbjaMl27JUapoyYpQm0anc=";
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
