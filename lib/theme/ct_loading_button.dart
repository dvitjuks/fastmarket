import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/custom_elevation.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CTLoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final Color? color;
  final String? icon;
  final bool isLoading;
  final bool invert;
  final bool withShadow;

  CTLoadingButton(this.text, this.onPressed,
      {this.width,
      this.color,
      this.icon,
      this.isLoading = false,
      this.withShadow = true,
      this.invert = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width ?? double.infinity,
        decoration: withShadow
            ? BoxDecoration(boxShadow: [
                BoxShadow(
                    color: onPressed == null
                        ? AppColors.disabledShadow.withOpacity(0.16)
                        : AppColors.enabledShadow.withOpacity(0.16),
                    spreadRadius: 5,
                    blurRadius: 20,
                    offset: Offset(0, 2))
              ])
            : BoxDecoration(),
        child: CustomElevation(
          color: onPressed == null
              ? AppColors.disabled1
              : color ?? AppColors.accentPurple,
          child: MaterialButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon != null && !isLoading
                    ? Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: SvgPicture.asset(
                          icon!,
                          height: 24,
                          width: 24,
                          color: AppColors.white,
                        ),
                      )
                    : Container(),
                isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        text,
                        style: AppTypography.body2_bold,
                      )
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            height: 64,
            elevation: 0,
            disabledElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0,
            textColor: getTextColor(),
            color: color ?? getColor(),
            disabledColor: AppColors.disabled1,
            disabledTextColor: AppColors.white,
            onPressed: isLoading ? null : onPressed,
          ),
        ));
  }

  Color getTextColor() => invert ? AppColors.accentPurple : AppColors.white;

  Color getColor() => invert ? AppColors.white : AppColors.accentPurple;
}
