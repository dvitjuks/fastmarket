import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomElevation extends StatelessWidget {
  final Widget child;
  final Color color;

  CustomElevation({required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withOpacity(0.16),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: this.child,
    );
  }
}
