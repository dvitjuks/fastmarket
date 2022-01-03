import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/model/advertisement.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';

class AdvertListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Advertisement advertisement;

  AdvertListTile({required this.onTap, required this.advertisement});

  @override
  Widget build(BuildContext context) {
    const placeholder =
        "https://media.istockphoto.com/vectors/thumbnail-image-vector-graphic-vector-id1147544807?k=20&m=1147544807&s=612x612&w=0&h=pBhz1dkwsCMq37Udtp9sfxbjaMl27JUapoyYpQm0anc=";

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CachedNetworkImage(
                imageUrl: advertisement.imageUrl ?? placeholder,
                imageBuilder: (context, imageProvider) => Container(
                      width: 100.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fitWidth),
                      ),
                    ),
                placeholder: (context, url) =>
                    const SizedBox(width: 100, height: 70)),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      advertisement.title,
                      style: AppTypography.headline4.copyWith(color: AppColors.textBlue),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Category: ${advertisement.category}",
                      style: AppTypography.caption2.copyWith(color: AppColors.disabledShadow),
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
