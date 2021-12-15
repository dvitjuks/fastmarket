import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:app/generated/locale_keys.g.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CTModalToolsSizesListItem extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isMetric;

  CTModalToolsSizesListItem(
      {required this.text,
      this.onPressed,
      this.isSelected = false,
      this.isMetric = true});

  @override
  Widget build(BuildContext context) {
    final leftBracketIndex = text.indexOf("(");
    return GestureDetector(
      child: Center(
        child: Container(
          width: double.infinity,
          color: isSelected
              ? AppColors.listItemSelectedBackground
              : AppColors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 24.0),
            child: RichText(
              text: isMetric
                  ? TextSpan(children: [
                      TextSpan(
                          text:
                              "${text.substring(0, leftBracketIndex)} ${LocaleKeys.general_mm_suffix.tr()} ",
                          style: AppTypography.body2_semibold
                              .copyWith(color: AppColors.textBlue)),
                      TextSpan(
                          text: text.substring(leftBracketIndex),
                          style: AppTypography.body2
                              .copyWith(color: AppColors.mainGrey))
                    ])
                  : TextSpan(children: [
                      TextSpan(
                          text: text.substring(0, leftBracketIndex),
                          style: AppTypography.body2_semibold
                              .copyWith(color: AppColors.textBlue)),
                      TextSpan(
                          text:
                              "${text.substring(leftBracketIndex, text.length - 1)} ${LocaleKeys.general_mm_suffix.tr()})",
                          style: AppTypography.body2
                              .copyWith(color: AppColors.mainGrey))
                    ]),
            ),
          ),
        ),
      ),
      onTap: () {
        onPressed?.call();
        Navigator.of(context).pop();
      },
    );
  }
}
