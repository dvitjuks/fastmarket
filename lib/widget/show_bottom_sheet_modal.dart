import 'dart:io';
import 'package:fastmarket/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


Future<dynamic> showFMModalBottomSheet<T extends Object>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {

  return Platform.isIOS
      ? showCupertinoModalBottomSheet(
      context: context,
      builder: builder,
      expand: true,
      enableDrag: false,
      closeProgressThreshold: 0.9,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.borderGrey,
      duration: const Duration(milliseconds: 200))
      : showModalBottomSheet(
      context: context,
      builder: (_) {
        final topPadding = MediaQuery.of(context).viewPadding.top;
        return Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: DraggableScrollableSheet(
            initialChildSize: 0.95,
            minChildSize: 0.5,
            builder: (context, sc) => builder(context),
          ),
        );
      },
      enableDrag: false,
      isScrollControlled: true,
      barrierColor: AppColors.borderGrey,
      backgroundColor: Colors.transparent);
}
