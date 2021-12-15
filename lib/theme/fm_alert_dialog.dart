import 'dart:io';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<dynamic> showSingleActionAlertDialog(BuildContext context, String title,
    String description, String actionText, Function onAction, Function onCancel,
    {bool cancelable = false}) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => alertDialog(
            title, description, actionText, onAction, onCancel, cancelable));
  } else {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => alertDialog(
            title, description, actionText, onAction, onCancel, cancelable));
  }
}

Widget alertDialog(String title, String description, String actionText,
    Function onAction, Function onCancel, bool oneAction) {
  if (Platform.isAndroid) {
    List<Widget> actionsList = [
      alertDialogAction(actionText.toUpperCase(), onAction)
    ];
    if (!oneAction) {
      actionsList.insert(
        0,
        alertDialogAction("CANCEL", onCancel),
      );
    }
    return AlertDialog(
        title: title == null ? null : Text(title),
        content: description == null ? null : Text(description),
        actions: actionsList);
  } else {
    List<Widget> actionsList = [
      alertDialogAction(actionText, onAction, isDefaultAction: false)
    ];
    if (!oneAction) {
      actionsList.insert(
          0, alertDialogAction("Cancel", onCancel, isDefaultAction: true));
    }
    return CupertinoAlertDialog(
        title: title == null ? null : Text(title),
        content: description == null
            ? null
            : Padding(
                child: Text(description),
                padding: EdgeInsets.only(top: 8.0),
              ),
        actions: actionsList);
  }
}

Future<dynamic> showMultipleActionAlertDialog(BuildContext context,
    String title, String description, List<Widget> actions) {
  if (Platform.isAndroid)
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            multipleActionsAlertDialog(title, description, actions));
  else
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) =>
            multipleActionsAlertDialog(title, description, actions));
}

Widget multipleActionsAlertDialog(
    String title, String description, List<Widget> actions) {
  if (Platform.isAndroid) {
    return AlertDialog(
        title: title == null ? null : Text(title),
        content: description == null ? null : Text(description),
        actions: actions);
  } else {
    return CupertinoAlertDialog(
        title: title == null ? null : Text(title),
        content: description == null
            ? null
            : Padding(
                child: Text(description),
                padding: EdgeInsets.only(top: 8.0),
              ),
        actions: actions);
  }
}

Future<dynamic> showAlertDialogWithTextField(
    BuildContext context,
    String title,
    String hintText,
    String actionText,
    Function onTextChange,
    Function onAction,
    Function onCancel) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => alertDialogWithTextField(
            title, hintText, actionText, onTextChange, onAction, onCancel));
  } else {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => alertDialogWithTextField(
            title, hintText, actionText, onTextChange, onAction, onCancel));
  }
}

Widget alertDialogWithTextField(
    String title,
    String hintText,
    String actionText,
    Function onTextChange,
    Function onAction,
    Function onCancel) {
  final TextEditingController controller = TextEditingController();

  if (Platform.isAndroid) {
    List<Widget> actionsList = [
      alertDialogAction("CANCEL", onCancel),
      alertDialogAction(actionText.toUpperCase(), onAction)
    ];

    return AlertDialog(
        title: title == null ? null : Text(title),
        content: TextField(
          controller: controller,
          onChanged: (value) => onTextChange(value),
          decoration: InputDecoration(hintText: hintText),
        ),
        actions: actionsList);
  } else {
    List<Widget> actionsList = [
      alertDialogAction("Cancel", onCancel, isDefaultAction: false),
      alertDialogAction(actionText, onAction, isDefaultAction: true)
    ];

    return CupertinoAlertDialog(
        title: Text(title),
        content: CupertinoTextField(
          controller: controller,
          onChanged: (value) => onTextChange(value),
          placeholder: hintText,
        ),
        actions: actionsList);
  }
}

Widget alertDialogAction(String actionText, Function onPressed,
    {bool isDefaultAction = false}) {
  if (Platform.isAndroid) {
    return TextButton(
      child: Text(actionText,
          style: AppTypography.caption1
              .copyWith(color: AppColors.purpleItemBackground)),
      onPressed: () => onPressed,
    );
  } else {
    return CupertinoDialogAction(
      isDefaultAction: isDefaultAction,
      child: Text(actionText),
      onPressed: () => onPressed,
    );
  }
}
