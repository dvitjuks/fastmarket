import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CTTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final Color? textColor;

  CTTextButton(this.text, this.onPressed, {this.width, this.textColor});

  // TODO progress bar in future
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      child: MaterialButton(
        child: Text(
          text,
          style: AppTypography.body2_semibold,
        ),
        height: 64,
        elevation: 0.0,
        disabledElevation: 0.0,
        focusElevation: 0.0,
        highlightElevation: 0.0,
        hoverElevation: 0.0,
        textColor: textColor ?? AppColors.accentPurple,
        color: AppColors.white,
        disabledTextColor: AppColors.disabled1,
        onPressed: onPressed,
      ),
    );
  }
}
