import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/ct_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CTFloatingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isTransparent;
  final bool progress;

  CTFloatingButton(this.text, this.onPressed,
      {this.isTransparent = false, this.progress = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: isTransparent
            ? Colors.transparent
            : AppColors.white.withOpacity(0.8),
        padding: EdgeInsets.only(top: 8, bottom: 16, left: 24, right: 24),
        child: Container(
            width: double.infinity,
            child: CTButton(
              text,
              onPressed,
              progress: progress,
            )));
  }
}
