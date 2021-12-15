import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CTListItem extends StatelessWidget {
  final String? icon;
  final String? title;
  final String? subtitle;
  final Color? iconColor;

  CTListItem({this.icon, this.title, this.subtitle, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: iconColor?.withOpacity(0.15)),
                width: 40,
                height: 40,
              ),
              icon != null
                  ? SvgPicture.asset(
                      icon!,
                      height: 24,
                      width: 24,
                      color: iconColor,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        SizedBox(
          width: 16,
        ),
        Flexible(
            child: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          color: AppColors.transparent,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: AppTypography.body3_semibold
                    .copyWith(color: AppColors.textBlue),
              ),
              SizedBox(
                height: 4,
              ),
              subtitle != null
                  ? Text(
                      subtitle!,
                      style: AppTypography.body4
                          .copyWith(color: AppColors.mainGrey),
                    )
                  : Container()
            ],
          ),
        )),
      ],
    );
  }
}
