import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PremiumPatternBadge extends StatelessWidget {
  final double headerHeight;

  PremiumPatternBadge({required this.headerHeight});

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 250),
      padding: EdgeInsets.only(
          top: 45.0 + headerHeight, left: 24.0, right: 24.0),
      child: Container(
        width: 140.0,
        height: 35.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: AppColors.patternYellow.withOpacity(0.2)
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
              LocaleKeys.patterns_premium_badge.tr(),
              style: AppTypography.caption1.copyWith(color: AppColors.patternYellow)
          ),
        ),
      ),
    );
  }
}