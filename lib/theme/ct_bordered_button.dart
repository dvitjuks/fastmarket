import 'dart:io';

import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CTBorderedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double borderRadius;

  CTBorderedButton(this.text, this.onPressed,
      {this.width, this.borderRadius = 20.0});

  // TODO progress bar in future
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: Platform.isIOS ? 16 : 0),
      width: width ?? double.infinity,
      child: MaterialButton(
        child: Text(
          text,
          style: AppTypography.body2_bold,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        height: 64,
        elevation: 0.0,
        disabledElevation: 0.0,
        focusElevation: 0.0,
        highlightElevation: 0.0,
        hoverElevation: 0.0,
        textColor: AppColors.accentPurple,
        color: AppColors.accentPurple.withOpacity(0.1),
        disabledColor: AppColors.disabled1,
        disabledTextColor: AppColors.white,
        onPressed: onPressed,
      ),
    );
  }
}
