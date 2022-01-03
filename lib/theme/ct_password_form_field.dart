import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/icons_provider.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CTPasswordFormField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final Function? validator;
  final bool autovalidate;
  final VoidCallback? onFieldSubmitted;
  final FocusNode? focusNode;

  CTPasswordFormField(this.onChanged,
      {this.validator,
      this.autovalidate = false,
      this.onFieldSubmitted,
      this.focusNode});

  @override
  _CTPasswordFormFieldState createState() => _CTPasswordFormFieldState();
}

class _CTPasswordFormFieldState extends State<CTPasswordFormField> {
  var _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          focusNode: widget.focusNode,
          onFieldSubmitted: (_) {
            widget.onFieldSubmitted?.call();
          },
          autovalidateMode: widget.autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
          validator: widget.validator as String? Function(String?)?,
          obscureText: !_showPassword,
          cursorColor: AppColors.textBlue.withOpacity(0.7),
          style: AppTypography.body3.copyWith(color: AppColors.textBlue),
          onChanged: widget.onChanged,
          decoration: const InputDecoration(
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.errorRed),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.errorRed),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.borderGrey),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textBlue),
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 8),
            child: _buildIcon(),
          ),
        )
      ],
    );
  }

  Widget _buildIcon() => GestureDetector(
      onTap: () => setState(() {
            _showPassword = !_showPassword;
          }),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          _showPassword ? IconsProvider.EYE_HIDDEN : IconsProvider.EYE,
          width: 24,
          height: 24,
          color: AppColors.mainGrey,
        ),
      ));
}
