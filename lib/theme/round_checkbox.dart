// Copy of https://github.com/rodrigobastosv/round_check_box from commit hash 7055f245f4123439740b953b72253404500008e8
// with changes required by app designs
import 'package:app/app/theme/colors.dart';
import 'package:flutter/material.dart';

///Widget that draw a beautiful checkbox rounded. Provided with animation if wanted
class RoundCheckBox extends StatefulWidget {
  const RoundCheckBox({
    Key? key,
    this.isChecked,
    this.isDisabled,
    this.disabledColor,
    this.disabledBorderColor,
    this.disabledWidget,
    this.checkedWidget,
    this.uncheckedWidget,
    this.checkedColor,
    this.uncheckedColor,
    this.checkedBorderColor,
    this.uncheckedBorderColor,
    this.size,
    this.iconSize,
    this.animationDuration,
    this.tappableSpace,
    required this.onTap,
  }) : super(key: key);

  // Define padding in which icon should be tappable, otherwise the space it too small
  final EdgeInsets? tappableSpace;

  ///Define wether the checkbox is marked or not
  final bool? isChecked;

  ///Define whether the checkbox is disabled or not
  final bool? isDisabled;

  ///Define the color that is shown when Widget is disabled
  final Color? disabledColor;

  ///Define border color of the disabled widget
  final Color? disabledBorderColor;

  ///Define the widget that is shown when Widget is disabled
  final Widget? disabledWidget;

  ///Define the widget that is shown when Widgets is checked
  final Widget? checkedWidget;

  ///Define the widget that is shown when Widgets is unchecked
  final Widget? uncheckedWidget;

  ///Define the color that is shown when Widgets is checked
  final Color? checkedColor;

  ///Define the color that is shown when Widgets is unchecked
  final Color? uncheckedColor;

  ///Define the border of the checked widget
  final Color? checkedBorderColor;

  ///Define the border of the unchecked widget
  final Color? uncheckedBorderColor;

  ///Define the size of the checkbox
  final double? size;

  ///Define the size of the checkbox icon
  final double? iconSize;

  ///Define Function that os executed when user tap on checkbox
  final Function(bool?) onTap;

  ///Define the duration of the animation. If any
  final Duration? animationDuration;

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  bool isChecked = false;
  late bool isDisabled;
  Color? disabledColor;
  Color? disabledBorderColor;
  Widget? disabledWidget;
  late Duration animationDuration;
  double? size;
  double? iconSize;
  Widget? checkedWidget;
  Widget? uncheckedWidget;
  Color? checkedColor;
  Color? uncheckedColor;
  Color? checkedBorderColor;
  Color? uncheckedBorderColor;

  @override
  void initState() {
    isChecked = widget.isChecked ?? false;
    isDisabled = widget.isDisabled ?? false;
    disabledColor = widget.disabledColor ?? Colors.grey;
    disabledBorderColor = widget.disabledBorderColor ?? Colors.grey;
    disabledWidget = widget.disabledWidget ??
        Icon(Icons.check, size: iconSize ?? 20, color: Colors.white);
    animationDuration = widget.animationDuration ?? Duration(milliseconds: 500);
    size = widget.size ?? 40.0;
    iconSize = widget.iconSize;
    checkedColor = widget.checkedColor ?? Colors.green;
    checkedBorderColor = widget.checkedBorderColor ?? Colors.grey;
    uncheckedBorderColor = widget.uncheckedBorderColor ?? Colors.grey;
    checkedWidget = widget.checkedWidget ??
        Icon(Icons.check, size: iconSize ?? 20, color: Colors.white);
    uncheckedWidget = widget.uncheckedWidget ?? const SizedBox.shrink();
    super.initState();
  }

  @override
  void didUpdateWidget(RoundCheckBox oldWidget) {
    isChecked = widget.isChecked ?? false;
    uncheckedColor =
        widget.uncheckedColor ?? Theme.of(context).scaffoldBackgroundColor;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isChecked = !isChecked);
        widget.onTap(isChecked);
      },
      child: ClipRRect(
          borderRadius: BorderRadius.circular(size! / 2),
          child: Container(
            color: AppColors.transparent,
            padding: widget.tappableSpace ?? EdgeInsets.zero,
            child: AnimatedContainer(
              duration: animationDuration,
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: _color,
                border: Border.all(
                  color: _borderColor != null ? _borderColor! : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(size! / 2),
              ),
              child: _widget,
            ),
          )),
    );
  }

  Color? get _color {
    if (isDisabled) {
      return disabledColor;
    } else if (isChecked) {
      return checkedColor;
    } else {
      return uncheckedColor;
    }
  }

  Color? get _borderColor {
    if (isDisabled) {
      return disabledBorderColor;
    } else if (isChecked) {
      return checkedBorderColor;
    } else {
      return uncheckedBorderColor;
    }
  }

  Widget? get _widget {
    if (isDisabled) {
      return disabledWidget;
    } else if (isChecked) {
      return checkedWidget;
    } else {
      return uncheckedWidget;
    }
  }
}
