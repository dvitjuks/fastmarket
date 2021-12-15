import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CTModalTextListItem extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSelected;

  static const itemHeight = 48.0;

  CTModalTextListItem(
      {required this.text, this.onPressed, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Container(
            height: itemHeight,
            width: double.infinity,
            color: isSelected
                ? AppColors.listItemSelectedBackground
                : AppColors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 24.0),
              child: Text(text,
                  style:
                      AppTypography.body2.copyWith(color: AppColors.textBlue)),
            )),
      ),
      onTap: () {
        onPressed?.call();
        Navigator.of(context).pop();
      },
    );
  }
}
