import 'dart:io';

import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/custom_elevation.dart';
import 'package:app/app/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CTCancelButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;

  CTCancelButton(this.text, this.onPressed, {this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 16 : 0),
        width: width ?? double.infinity,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: AppColors.cancelOrange.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 20,
              offset: Offset(0, 2))
        ]),
        child: CustomElevation(
          color: AppColors.cancelOrange,
          child: MaterialButton(
            child: Text(
              text,
              style: AppTypography.body2_bold,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            height: 64,
            elevation: 0.0,
            disabledElevation: 0.0,
            focusElevation: 0.0,
            highlightElevation: 0.0,
            hoverElevation: 0.0,
            textColor: AppColors.errorRed,
            color: AppColors.cancelOrange,
            onPressed: onPressed,
          ),
        ));
  }
}
