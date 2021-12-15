import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:flutter/material.dart';

class CTModalHeader extends StatelessWidget {
  final String title;
  final double height;
  final Widget body;

  const CTModalHeader(
      {Key? key, required this.title, required this.height, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        padding: const EdgeInsets.only(top: 20),
        child: Stack(children: [
          Column(children: [
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 10.0, left: 24.0, right: 24.0),
              child: Row(children: [
                Text(
                  title,
                  style:
                      AppTypography.headline4.apply(color: AppColors.textBlack),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  color: AppColors.mainGrey,
                  onPressed: () => Navigator.of(context).pop(),
                )
              ]),
            ),
            body,
            const SizedBox(
              height: 16,
            )
          ])
        ]));
  }
}
