import 'package:app/app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CTCircleIcon extends StatelessWidget {
  final bool enabled;
  final String assetIcon;
  final IconData? icon;
  final VoidCallback? onTap;
  final double bgSize;
  final double iconSize;

  CTCircleIcon(
      {this.enabled = false,
      required this.assetIcon,
      this.icon,
      this.onTap,
      this.bgSize = 32,
      this.iconSize = 24});

  @override
  Widget build(BuildContext context) {
    final iconOffset = bgSize / 2 - iconSize / 2;
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        customBorder: CircleBorder(side: BorderSide()),
        child: Stack(
          children: [
            Container(
                height: bgSize,
                width: bgSize,
                decoration: BoxDecoration(
                    color: enabled
                        ? AppColors.accentPurple.withOpacity(0.1)
                        : AppColors.disabled2.withOpacity(0.1),
                    shape: BoxShape.circle)),
            Positioned(
              top: iconOffset,
              left: iconOffset,
              child: icon != null
                  ? Icon(
                      icon,
                      color: enabled
                          ? AppColors.accentPurple
                          : AppColors.disabled2,
                      size: iconSize,
                    )
                  : SvgPicture.asset(
                      assetIcon,
                      height: iconSize,
                      width: iconSize,
                    ),
            )
          ],
        ),
        onTap: enabled ? onTap : null,
        highlightColor: AppColors.accentPurple.withOpacity(0.1),
      ),
    );
  }
}
