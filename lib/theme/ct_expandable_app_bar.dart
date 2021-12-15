import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/ct_back_button.dart';
import 'package:app/app/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CTExpandableAppBar extends StatelessWidget {
  final String header;
  final PreferredSizeWidget? bottom;
  final double? collapsedHeight;

  const CTExpandableAppBar(
      {Key? key, required this.header, this.bottom, this.collapsedHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        backgroundColor: AppColors.white,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        automaticallyImplyLeading: false,
        expandedHeight: bottom != null ? 130 : 100,
        collapsedHeight: collapsedHeight,
        pinned: true,
        bottom: bottom,
        leading: CTBackButton(
          AppColors.accentPurple,
          AppColors.accentPurple,
          padding: 12,
        ),
        elevation: 0.0,
        flexibleSpace: LayoutBuilder(
          builder: (context, constraints) {
            final collapsed = constraints.biggest.height ==
                (bottom != null && collapsedHeight != null
                    ? MediaQuery.of(context).padding.top +
                        (collapsedHeight ?? 0)
                    : MediaQuery.of(context).padding.top + kToolbarHeight);

            final offsetTitle =
                constraints.biggest.height - (bottom != null ? 55 : 30) <=
                    MediaQuery.of(context).padding.top + kToolbarHeight;

            return Container(
              padding: bottom != null ? EdgeInsets.only(bottom: 24.0) : null,
              decoration: ShapeDecoration(
                  shape: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: collapsed
                        ? AppColors.backgroundBorder
                        : AppColors.white),
              )),
              child: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding:
                    EdgeInsets.only(left: offsetTitle ? 48 : 24, bottom: 16.0),
                title: Text(
                  header,
                  style:
                      AppTypography.app_bar.copyWith(color: AppColors.textBlue),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
