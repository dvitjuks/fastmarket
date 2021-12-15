import 'dart:io';

import 'package:fastmarket/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FMPopupAction extends StatelessWidget {
  final VoidCallback onPressed;
  final String? title;
  final bool isDestructiveAction;

  FMPopupAction(
      {required this.onPressed, this.title, this.isDestructiveAction = false});

  @override
  Widget build(BuildContext context) {
    final child = Text(title ?? "",
        style: TextStyle(
            color: isDestructiveAction
                ? AppColors.errorRed
                : AppColors.textBlue));
    if (Platform.isAndroid) {
      return SimpleDialogOption(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: child,
        ),
      );
    } else {
      return CupertinoActionSheetAction(
        onPressed: onPressed,
        isDestructiveAction: isDestructiveAction,
        child: child,
      );
    }
  }
}
