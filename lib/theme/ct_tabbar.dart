import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CTTabBar extends StatelessWidget {
  final List<String> tabs;
  final TabController? controller;

  const CTTabBar(this.tabs, this.controller);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      controller: controller,
      indicatorColor: AppColors.accentPurple,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: AppColors.textBlue,
      labelStyle: AppTypography.body3_semibold,
      unselectedLabelStyle: AppTypography.body3_semibold,
      unselectedLabelColor: AppColors.mainGrey,
      tabs: _mapStringsToTabs(),
    );
  }

  List<Widget> _mapStringsToTabs() => tabs.map((text) => Padding(child: Text(text), padding: EdgeInsets.only(bottom: 8.0),)).toList();
}
