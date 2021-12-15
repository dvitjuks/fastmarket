import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:app/app/tools/add_yarn/pages/add_yarn_color_picker.dart';
import 'package:app/app/tools/inventory/model/inventory_color_type.dart';
import 'package:app/app/utils/string_utils.dart';
import 'package:app/generated/locale_keys.g.dart';
import 'package:domain/inventory/yarns/yarn_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? isEditable;
  final TextInputType? keyboardType;
  final Function(String)? textChangeCallback;
  final String? icon;
  final String? placeholder;
  final int? maxLines;
  final double? expectedHeight;
  final String? title;
  final double? minHeight;
  final bool required;

  InputField(
      {this.controller,
      this.isEditable,
      this.keyboardType,
      this.textChangeCallback,
      this.placeholder,
      this.icon,
      this.maxLines = 1,
      this.expectedHeight,
      this.title,
      this.minHeight,
      this.required = false});

  @override
  State<StatefulWidget> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _isEditing = false;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    widget.controller?.addListener(_textfieldChangeListener);
    super.initState();
  }

  _textfieldChangeListener() async {
    // because apparently flutter works too fast
    await Future.delayed(const Duration(milliseconds: 100));

    if (this.mounted) {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_textfieldChangeListener);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textField = CupertinoTextField(
      enabled: widget.isEditable,
      focusNode: _focusNode,
      style: AppTypography.body3.copyWith(color: AppColors.textBlue),
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      placeholder: widget.placeholder ?? "",
      placeholderStyle: AppTypography.body3.copyWith(color: AppColors.mainGrey),
      maxLines: widget.maxLines,
      onChanged: (text) {
        if (widget.textChangeCallback != null) widget.textChangeCallback!(text);
      },
      decoration: BoxDecoration(),
    );

    Widget mainChild;

    final icon = widget.icon;
    if (icon != null && icon.isNotEmpty == true) {
      var image = SvgPicture.asset(icon);

      mainChild = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          image,
          const SizedBox(
            width: 8,
          ),
          Expanded(child: textField)
        ],
      );
    } else {
      mainChild = textField;
    }

    Widget container = Container(
        height: widget.expectedHeight == 0 ? null : 56,
        decoration: BoxDecoration(
            color: widget.isEditable == true
                ? Colors.white
                : AppColors.background2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isEditing ? AppColors.accentPurple : AppColors.borderGrey,
            )),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: mainChild,
        ));

    List<Widget> columnChildren = [
      widget.minHeight == null
          ? container
          : ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: widget.minHeight!,
                maxHeight: double.infinity,
              ),
              child: container)
    ];

    if (widget.title?.isNotEmpty == true) {
      columnChildren.insertAll(0, [
        Row(
          children: [
            Text(widget.title!,
                style: AppTypography.body3.copyWith(color: AppColors.mainGrey)),
            const Spacer(),
            widget.required
                ? Text(LocaleKeys.required_field.tr(),
                    style: AppTypography.body3
                        .copyWith(color: AppColors.textGreen))
                : Container()
          ],
        ),
        const SizedBox(
          height: 8,
        )
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }
}

class ClickInputField extends StatefulWidget {
  final String? text;
  final bool isPlaceholder;
  final String? iconName;
  final bool? isEnabled;
  final VoidCallback? onClick;
  final String? title;
  final double? height;
  final bool flexibleHeight;
  final bool isRequired;

  ClickInputField(
      {this.text,
      this.isPlaceholder = false,
      this.iconName,
      this.onClick,
      this.isEnabled,
      this.title,
      this.height,
      this.flexibleHeight = false,
      this.isRequired = false});

  @override
  State<StatefulWidget> createState() => _ClickInputFieldState();
}

class _ClickInputFieldState extends State<ClickInputField> {
  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [
      GestureDetector(
          onTap: () {
            if ((widget.isEnabled ?? true)) {
              if (widget.onClick != null) widget.onClick!();
            }
          },
          child: Container(
            height: widget.flexibleHeight ? null : (widget.height ?? 56),
            constraints: BoxConstraints(
                minHeight: widget.flexibleHeight ? 56 : (widget.height ?? 56)),
            decoration: BoxDecoration(
                color: (widget.isEnabled ?? true)
                    ? Colors.white
                    : AppColors.background2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.borderGrey,
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 12, vertical: widget.flexibleHeight ? 12 : 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.text ?? "",
                      style: widget.isPlaceholder
                          ? AppTypography.body3
                              .copyWith(color: AppColors.mainGrey)
                          : AppTypography.body3
                              .copyWith(color: AppColors.textBlue),
                      maxLines: null,
                    ),
                  ),
                  widget.iconName != null
                      ? SvgPicture.asset(widget.iconName!)
                      : const SizedBox()
                ],
              ),
            ),
          ))
    ];

    if (widget.title?.isNotEmpty == true) {
      columnChildren.insertAll(0, [
        Row(children: [
          Text(widget.title ?? '',
              style: AppTypography.body3.copyWith(color: AppColors.mainGrey)),
          const Spacer(),
          widget.isRequired
              ? Text(LocaleKeys.required_field.tr(),
                  style:
                      AppTypography.body3.copyWith(color: AppColors.textGreen))
              : Container()
        ]),
        const SizedBox(
          height: 8,
        )
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }
}

class ColorPickerInputField extends StatefulWidget {
  final Color? color;
  final String? colorGroup;
  final String? text;
  final String? iconName;
  final bool? isEnabled;
  final VoidCallback? onClick;
  final String? title;
  final bool isRequired;
  final bool isPlaceholder;

  ColorPickerInputField(
      {this.color,
      this.colorGroup,
      this.text,
      this.iconName,
      this.onClick,
      this.isEnabled,
      this.isRequired = false,
      this.isPlaceholder = false,
      this.title});

  @override
  State<StatefulWidget> createState() => _ColorPickerInputFieldState();
}

class _ColorPickerInputFieldState extends State<ColorPickerInputField> {
  @override
  Widget build(BuildContext context) {
    List<Widget> containerKids = [
      Text(
        widget.text ?? "",
        style: AppTypography.body3.copyWith(
            color:
                widget.isPlaceholder ? AppColors.mainGrey : AppColors.textBlue),
      ),
      const Spacer(),
      widget.iconName != null
          ? SvgPicture.asset(widget.iconName!)
          : const SizedBox()
    ];

    if (widget.color != null) {
      var colorWidgets = [
        ColorPickerItemIcon(
            radius: 12,
            color:
                widget.colorGroup == YarnType.fantasy.yarnType.capitalize() ||
                        widget.text == describeEnum(InventoryColorType.Gradient)
                    ? null
                    : widget.color),
        const SizedBox(width: 16)
      ];

      containerKids.insertAll(0, colorWidgets);
    }
    List<Widget> columnChildren = [
      GestureDetector(
          onTap: () {
            if ((widget.isEnabled ?? true)) {
              if (widget.onClick != null) widget.onClick!();
            }
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
                color: (widget.isEnabled ?? true)
                    ? Colors.white
                    : AppColors.background2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.borderGrey,
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: containerKids,
              ),
            ),
          ))
    ];

    if (widget.title?.isNotEmpty == true) {
      columnChildren.insertAll(0, [
        Row(children: [
          Text(widget.title!,
              style: AppTypography.body3.copyWith(color: AppColors.mainGrey)),
          const Spacer(),
          widget.isRequired
              ? Text(LocaleKeys.required_field.tr(),
                  style:
                      AppTypography.body3.copyWith(color: AppColors.textGreen))
              : Container()
        ]),
        const SizedBox(
          height: 8,
        )
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }
}
