import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/icons_provider.dart';
import 'package:app/app/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? isEditable;
  final TextInputType? keyboardType;
  final Function(String)? textChangeCallback;
  final String? placeholder;
  final double? expectedHeight;

  SearchField(
      {this.controller,
      this.isEditable,
      this.keyboardType,
      this.textChangeCallback,
      this.placeholder,
      this.expectedHeight});

  @override
  State<StatefulWidget> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
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
      cursorColor: AppColors.accentPurple,
      enabled: widget.isEditable,
      focusNode: _focusNode,
      style: AppTypography.body3.copyWith(color: AppColors.textBlue),
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      placeholder: widget.placeholder ?? "",
      placeholderStyle: AppTypography.body3.copyWith(color: AppColors.mainGrey),
      maxLines: 1,
      onChanged: (text) {
        widget.textChangeCallback!(text);
      },
      decoration: BoxDecoration(),
    );

    var clearButton = SvgPicture.asset(IconsProvider.SEARCH_CLEAR);

    Widget mainChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 4,
        ),
        SvgPicture.asset(IconsProvider.SEARCH_ICON,
            color: _isEditing ? AppColors.accentPurple : AppColors.mainGrey),
        SizedBox(
          width: 4,
        ),
        Expanded(child: textField),
        SizedBox(
          width: 4,
        ),
        _isEditing
            ? GestureDetector(
                onTap: _clearText,
                child: clearButton,
              )
            : Container(),
        SizedBox(
          width: 4,
        ),
      ],
    );

    List<Widget> columnChildren = [
      Container(
        height: widget.expectedHeight == 0 ? null : 48,
        decoration: BoxDecoration(
            color: widget.isEditable == true
                ? Colors.white
                : AppColors.background2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: _isEditing
                  ? AppColors.accentPurple.withOpacity(0.1)
                  : AppColors.white,
            )),
        child: Container(
            decoration: BoxDecoration(
                color: widget.isEditable == true
                    ? Colors.white
                    : AppColors.background2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isEditing
                      ? AppColors.accentPurple
                      : AppColors.borderGrey,
                )),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: mainChild,
            )),
      )
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }

  void _clearText() {
    widget.controller?.text = "";
    if (widget.textChangeCallback != null) {
      widget.textChangeCallback!("");
    }
  }
}
