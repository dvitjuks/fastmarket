import 'dart:io';

import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CTAlert<T> extends StatelessWidget {
  final String? title;
  final String? content;
  final String? buttonTitle;
  final VoidCallback? onPressed;
  final bool withSingleButton;

  const CTAlert(
      {this.title,
      this.content,
      this.buttonTitle,
      this.onPressed,
      this.withSingleButton = false});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> selectedValue(BuildContext context) async {
    if (Platform.isAndroid)
      return _showAndroidLogoutConfirmationDialog(context);
    else
      return _showIosLogoutConfirmationDialog(context);
  }

  Future<void> _showIosLogoutConfirmationDialog(BuildContext context) async {
    List<Widget> actions = <Widget>[];
    if (withSingleButton == false) {
      actions.add(CupertinoDialogAction(
        child: Text(LocaleKeys.general_cancel_button.tr(),
            style: AppTypography.dialogButtonCancel
                .apply(color: AppColors.accentPurple)),
        onPressed: () {
          Navigator.pop(context);
        },
      ));
    }
    actions.add(CupertinoDialogAction(
      child: Text(buttonTitle ?? "",
          style: AppTypography.dialogButton
              .copyWith(fontWeight: FontWeight.bold)
              .apply(color: AppColors.accentPurple)),
      onPressed: () {
        if (onPressed != null) {
          onPressed?.call();
        }
        Navigator.of(context).pop();
      },
    ));
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title ?? ""),
            content: content != null
                ? Padding(
                    child: Text(
                      content ?? "",
                      style: AppTypography.dialogText,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                  )
                : Container(),
            actions: actions,
          );
        });
  }

  Future<void> _showAndroidLogoutConfirmationDialog(
      BuildContext context) async {
    List<Widget> actions = <Widget>[];
    if (withSingleButton == false) {
      actions.add(FlatButton(
        child: Text(LocaleKeys.general_cancel_button.tr(),
            style: AppTypography.dialogButtonCancel
                .apply(color: AppColors.accentPurple)),
        onPressed: () {
          Navigator.pop(context);
        },
      ));
    }
    actions.add(FlatButton(
      child: Text(buttonTitle ?? "",
          style: AppTypography.dialogButton
              .copyWith(fontWeight: FontWeight.bold)
              .apply(color: AppColors.accentPurple)),
      onPressed: () {
        if (onPressed != null) {
          onPressed?.call();
        }
        Navigator.of(context).pop();
      },
    ));
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? ""),
            content: Padding(
              child: Text(
                content != null ? content! : "",
                style: AppTypography.dialogText
                    .copyWith(color: AppColors.textBlue),
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0),
            ),
            actions: actions,
          );
        });
  }
}
