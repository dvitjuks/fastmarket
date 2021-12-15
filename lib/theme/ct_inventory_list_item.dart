import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/ct_alert.dart';
import 'package:app/app/theme/ct_popup.dart';
import 'package:app/app/theme/ct_popup_action.dart';
import 'package:app/app/theme/icons_provider.dart';
import 'package:app/app/theme/typography.dart';
import 'package:app/app/tools/inventory/model/inventory_color.dart';
import 'package:app/app/tools/inventory/model/inventory_color_type.dart';
import 'package:app/app/utils/hex_color.dart';
import 'package:app/generated/locale_keys.g.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CTInventoryListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String icon;
  final VoidCallback onDelete;
  final InventoryColor? color;
  final bool isNeedle;

  const CTInventoryListItem(
      {required this.title,
      this.subtitle,
      required this.icon,
      required this.onDelete,
      this.isNeedle = false,
      this.color});

  @override
  Widget build(BuildContext context) {
    final leftBracketIndex = title.indexOf("(");
    final colorName = color?.title;
    final colorHex = color?.color;
    return Container(
      height: 80,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.listItemBorder, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppColors.background2),
      child: Padding(
        padding: EdgeInsets.only(left: 18, right: 18),
        child: Row(
          children: [
            colorName != describeEnum(InventoryColorType.Gradient)
                ? Container(
                    height: 32,
                    width: 32,
                    child: SvgPicture.asset(
                      icon,
                      color: colorHex != null ? HexColor(colorHex) : null,
                    ))
                : Container(
                    height: 32,
                    width: 32,
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.8, 0.0),
                          colors: [
                            AppColors.gradientFirst,
                            AppColors.gradientSecond,
                            AppColors.gradientThird,
                            AppColors.gradientFourth,
                            AppColors.gradientFifth,
                          ],
                          tileMode: TileMode.repeated,
                        ).createShader(bounds);
                      },
                      child: SvgPicture.asset(
                        icon,
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: title.substring(0, leftBracketIndex),
                            style: AppTypography.body2_bold
                                .copyWith(color: AppColors.textBlue)),
                        TextSpan(
                            text: title.substring(leftBracketIndex),
                            style: AppTypography.body2_semibold
                                .copyWith(color: AppColors.mainGrey))
                      ]),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle ?? "",
                        style: AppTypography.body3
                            .copyWith(color: AppColors.mainGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                child: InkWell(
                  customBorder: CircleBorder(side: BorderSide()),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                    child: SvgPicture.asset(
                      IconsProvider.MORE,
                      color: AppColors.disabled2,
                    ),
                  ),
                  onTap: () => _showDeleteOption(context),
                  highlightColor: AppColors.disabled2.withOpacity(0.1),
                ))
          ],
        ),
      ),
    );
  }

  void _showDeleteOption(BuildContext context) async {
    final popup = CTPopup(
      actions: [
        CTPopupAction(
          title: isNeedle
              ? LocaleKeys.needle_delete_action.tr()
              : LocaleKeys.hooks_delete_action.tr(),
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    );
    final showConfirmation = await popup.selectedValue(context);
    if (showConfirmation == true) _showDeleteConfirmation(context);
  }

  void _showDeleteConfirmation(BuildContext context) async {
    final alert = CTAlert(
      title: isNeedle
          ? LocaleKeys.needle_delete_confirmation.tr()
          : LocaleKeys.hooks_delete_confirmation.tr(),
      buttonTitle: isNeedle
          ? LocaleKeys.needle_delete_action.tr()
          : LocaleKeys.hooks_delete_action.tr(),
      onPressed: onDelete,
    );
    await alert.selectedValue(context);
  }
}
