import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/icons_provider.dart';
import 'package:app/app/theme/typography.dart';
import 'package:app/generated/locale_keys.g.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CTPromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  final VoidCallback onButtonPressed;
  final VoidCallback onCrossPressed;

  CTPromoBanner(
      {required this.title,
      required this.subtitle,
      required this.onButtonPressed,
      required this.onCrossPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.purpleBackground,
        border: Border.all(color: AppColors.purpleBorder, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Wrap(
                    children: [
                      Text(
                        title,
                        style: AppTypography.body2_semibold
                            .copyWith(color: AppColors.textBlue),
                      ),
                      Text(
                        subtitle,
                        style: AppTypography.body3
                            .copyWith(color: AppColors.textLightPurple),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20.0, left: 20.0, top: 16.0),
                  child: TextButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(double.infinity, 40)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.accentPurple),
                    ),
                    onPressed: onButtonPressed,
                    child: Text(
                      LocaleKeys.subscription_banner_button.tr(),
                      style:
                          AppTypography.body3.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  padding: EdgeInsets.only(right: 8.0),
                  alignment: Alignment.center,
                  icon: Icon(Icons.close),
                  color: AppColors.mainGrey,
                  onPressed: onCrossPressed,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  child: SvgPicture.asset(
                    IconsProvider.DIAMOND,
                    height: 72,
                    width: 72,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
