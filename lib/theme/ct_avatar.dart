import 'package:app/app/theme/animations.dart';
import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/icons_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CTAvatar extends StatelessWidget {
  final String? url;
  final double size;

  const CTAvatar(this.url, this.size);

  @override
  Widget build(BuildContext context) {
    // TODO placeholder
    final placeholder = Container(
      height: size,
      width: size,
      color: AppColors.accentPurple,
    );
    if (url == null) {
      return placeholder;
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FadeInImage.assetNetwork(
            imageErrorBuilder: (context, obj, st) => placeholder,
            placeholder: IconsProvider.PROJECTS_PLACEHOLDER,
            fadeInDuration: AppAnimations.defaultAnimationDuration,
            fadeOutDuration: AppAnimations.defaultAnimationDuration,
            fit: BoxFit.cover,
            image: url!,
            height: size,
            width: size,
          ));
    }
  }
}
