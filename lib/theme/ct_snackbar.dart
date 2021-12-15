import 'package:fastmarket/theme/colors.dart';
import 'package:flutter/material.dart';

class CTSnackBar extends SnackBar {
  CTSnackBar({required String text, SnackBarAction? action})
      : super(
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 0.0,
    action: action,
    backgroundColor: AppColors.snackbarGrey,
  );
}