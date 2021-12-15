import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/icons_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeaturedStar extends StatelessWidget {
  final bool hasPremium;

  FeaturedStar({required this.hasPremium});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 38.0,
        width: 38.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.textBlack.withOpacity(0.2),
                spreadRadius: -1,
                blurRadius: 3,
              )
            ]),
      ),
      Positioned(
        bottom: 6,
        left: 6,
        child: SvgPicture.asset(
          IconsProvider.STAR_FILLED,
          height: 26.0,
          width: 26.0,
          color: hasPremium ? AppColors.patternYellow : AppColors.checkboxGrey,
        ),
      ),
    ]);
  }
}
