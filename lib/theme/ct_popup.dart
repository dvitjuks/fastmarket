import 'dart:io';

import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FMPopup<T> extends StatelessWidget {
  final String? title;
  final List<Widget>? actions;

  const FMPopup({this.title, this.actions});

  Future<T?> selectedValue(BuildContext context) async {
    if (Platform.isAndroid) {
      return _androidPopup(context);
    } else {
      return _iosPopup(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<T?> _androidPopup(BuildContext context) async {
    final titleText = title;
    final titleWidget = titleText == null ? null : Text(titleText);

    return await showDialog<T>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => SimpleDialog(
              title: titleWidget,
              children: actions,
            ));
  }

  Future<T?> _iosPopup(BuildContext context) async {
    final titleText = title;
    final titleWidget = titleText == null
        ? null
        : Text(
            titleText,
            style: AppTypography.body1,
          );

    return await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: titleWidget,
        actions: actions,
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: AppColors.errorRed),
          ),
          isDefaultAction: true,
        ),
      ),
    );
  }
}
