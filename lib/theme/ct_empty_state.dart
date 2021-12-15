import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/icons_provider.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/cupertino.dart';

class CTEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final String? img;
  final double width;

  CTEmptyState(this.title, this.description, {this.img, this.width = 0.7});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * width,
          padding: EdgeInsets.only(bottom: 32),
          child: Image.asset(
            img ?? IconsProvider.PROJECTS_PLACEHOLDER,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16, right: 32, left: 32),
          child: Text(
            title,
            style: AppTypography.headline4.copyWith(color: AppColors.textBlue),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16, right: 32, left: 32),
          child: Text(description,
              style: AppTypography.body3.copyWith(
                color: AppColors.mainGrey,
              ),
              textAlign: TextAlign.center),
        )
      ],
    );
  }
}
