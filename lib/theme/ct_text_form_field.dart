import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CTTextFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final Function? formFieldValidator;
  final bool autovalidate;
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final bool enableInteractiveSelection;
  final bool obscureText;

  CTTextFormField(this.onChanged,
      {this.autovalidate = false,
      this.formFieldValidator,
      this.controller,
      this.initialValue,
      this.focusNode,
      this.enableInteractiveSelection = true,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      focusNode: focusNode,
      controller: controller,
      autovalidate: autovalidate,
      validator: formFieldValidator as String? Function(String?)?,
      obscureText: obscureText,
      enableInteractiveSelection: enableInteractiveSelection,
      cursorColor: AppColors.textBlue.withOpacity(0.7),
      style: AppTypography.body3.copyWith(color: AppColors.textBlue),
      onChanged: onChanged,
      decoration: const InputDecoration(
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.errorRed),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.errorRed),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          errorStyle: TextStyle(color: AppColors.errorRed),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderGrey),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textBlue),
              borderRadius: BorderRadius.all(Radius.circular(6)))),
    );
  }
}
