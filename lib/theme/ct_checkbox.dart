import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/round_checkbox.dart';
import 'package:flutter/cupertino.dart';

class CTCheckBox extends StatelessWidget {
  final bool isChecked;
  final BooleanCallback onChecked;
  final double? size;
  final double? iconSize;
  final EdgeInsets? tappableSpace;
  final bool disabled;

  const CTCheckBox(this.isChecked, this.onChecked,
      {this.size, this.iconSize, this.tappableSpace, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return RoundCheckBox(
      size: size ?? 24.0,
      iconSize: iconSize,
      animationDuration: Duration(milliseconds: 200),
      checkedColor: AppColors.accentPurple,
      checkedBorderColor: AppColors.accentPurple,
      uncheckedBorderColor: AppColors.checkboxGrey,
      uncheckedColor: AppColors.transparent,
      isChecked: isChecked,
      isDisabled: disabled,
      disabledColor: AppColors.accentPurple.withOpacity(0.5),
      disabledBorderColor: AppColors.accentPurple.withOpacity(0.5),
      onTap: (value) {
        if (!disabled) {
          onChecked(value ?? false);
        }
      },
      tappableSpace: tappableSpace,
    );
  }
}

typedef BooleanCallback = void Function(bool selected);
