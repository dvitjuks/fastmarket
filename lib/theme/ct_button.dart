import 'dart:io';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/custom_elevation.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';

class CTButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final bool invert;
  final bool withShadow;
  final bool progress;

  CTButton(this.text, this.onPressed,
      {this.width, this.invert = false, this.withShadow = true, this.progress = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 16 : 0),
        width: width ?? double.infinity,
        decoration: withShadow
            ? BoxDecoration(boxShadow: [
                BoxShadow(
                    color: onPressed == null
                        ? AppColors.disabledShadow.withOpacity(0.16)
                        : AppColors.enabledShadow.withOpacity(0.16),
                    spreadRadius: 5,
                    blurRadius: 20,
                    offset: const Offset(0, 2))
              ])
            : const BoxDecoration(),
        child: CustomElevation(
          color:
              onPressed == null ? AppColors.disabled1 : AppColors.accentPurple,
          child: MaterialButton(
            child: progress
                ? const CircularProgressIndicator.adaptive(backgroundColor: AppColors.white)
                : Text(
                    text,
                    style: AppTypography.body2_bold,
                  ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            height: 48,
            elevation: 0.0,
            disabledElevation: 0.0,
            focusElevation: 0.0,
            highlightElevation: 0.0,
            hoverElevation: 0.0,
            textColor: getTextColor(),
            color: getColor(),
            disabledColor: AppColors.disabled1,
            disabledTextColor: AppColors.white,
            onPressed: onPressed,
          ),
        ));
  }

  Color getTextColor() => invert ? AppColors.patternBlue : AppColors.white;

  Color getColor() => invert ? AppColors.white : AppColors.patternBlue;
}
