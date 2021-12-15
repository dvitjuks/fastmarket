import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/icons_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CTBackButton extends StatelessWidget {
  final Color iconColor;
  final Color highlightColor;
  final VoidCallback? onBack;
  final double? padding;
  final ArgumentCallback? argument;
  final bool shouldPop;

  CTBackButton(this.iconColor, this.highlightColor,
      {this.onBack, this.padding, this.argument, this.shouldPop = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onBack?.call();
        Navigator.of(context).pop(argument?.call());
      },
      child: Container(
        color: AppColors.transparent,
        padding: EdgeInsets.all(padding ?? 16),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(side: BorderSide()),
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 2, top: 4, bottom: 4),
              child: SvgPicture.asset(
                IconsProvider.BACK,
                color: iconColor,
              ),
            ),
            onTap: () {
              onBack?.call();
              if (shouldPop) {
                Navigator.of(context).pop(argument?.call());
              }
            },
            highlightColor: highlightColor.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}

typedef ArgumentCallback = dynamic Function();
