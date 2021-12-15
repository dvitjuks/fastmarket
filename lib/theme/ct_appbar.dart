import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_back_button.dart';
import 'package:flutter/material.dart';

class CTAppBar extends AppBar {
  CTAppBar()
      : super(
            elevation: 0,
            backgroundColor: AppColors.white,
            leading: CTBackButton(
              AppColors.textBlue,
              AppColors.textBlue,
              padding: 12,
            ));
}
