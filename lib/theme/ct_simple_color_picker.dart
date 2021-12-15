import 'package:app/app/theme/colors.dart';
import 'package:app/app/theme/typography.dart';
import 'package:app/app/tools/inventory/model/inventory_color.dart';
import 'package:app/app/tools/inventory/model/inventory_color_type.dart';
import 'package:app/app/tools/inventory/model/inventory_color_type_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ItemSelectColorCallback = void Function(InventoryColor color);

class CTSimpleColorPicker extends StatelessWidget {
  final List<InventoryColorRow> colors;
  final String header;
  final double height;
  final ItemSelectColorCallback onColorSelect;
  final InventoryColor? selectedColor;

  static const rowHeight = 48.0;

  CTSimpleColorPicker(
      {required this.colors,
      required this.header,
      required this.height,
      required this.onColorSelect,
      this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(top: 32.0),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20.0, left: 24.0, right: 24.0),
          child: Row(children: [
            Text(
              header,
              style: AppTypography.headline4.apply(color: AppColors.textBlack),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.close),
              color: AppColors.mainGrey,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return ColorsSelectionWidget(
                row: colors[index],
                onColorSelect: onColorSelect,
                selectedColor: selectedColor,
              );
            },
          ),
        ),
      ]),
    );
  }
}

class ColorsSelectionWidget extends StatelessWidget {
  final InventoryColorRow row;
  final ItemSelectColorCallback onColorSelect;
  final InventoryColor? selectedColor;

  const ColorsSelectionWidget(
      {Key? key,
      required this.row,
      required this.onColorSelect,
      this.selectedColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: row.color
              .map((e) => GestureDetector(
                  onTap: () {
                    onColorSelect(e);
                    Navigator.of(context).pop();
                  },
                  child: ColorPickerItemIcon(
                    radius: 24,
                    color: e,
                    isSelected: selectedColor == e,
                  )))
              .toList(),
        )
      ],
    );
  }
}

class ColorPickerItemIcon extends StatelessWidget {
  final InventoryColor color;
  final double radius;
  final bool isSelected;

  ColorPickerItemIcon(
      {required this.color, required this.radius, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(isSelected ? 6 : 10),
      child: Stack(alignment: Alignment.center, children: [
        isSelected
            ? Container(
                height: radius * 2 + 8,
                width: radius * 2 + 8,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.accentPurple, width: 1),
                    borderRadius: BorderRadius.circular(radius + 4)),
              )
            : const SizedBox(),
        Container(
          height: radius * 2,
          width: radius * 2,
          decoration: color.type == InventoryColorType.Gradient
              ? _getGradientItem()
              : _getSolidColorItem(color.getColor()),
        ),
      ]),
    );
  }

  BoxDecoration _getSolidColorItem(Color? color) {
    return BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(radius));
  }

  BoxDecoration _getGradientItem() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
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
        ));
  }
}
