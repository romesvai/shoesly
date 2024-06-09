import 'package:flutter/material.dart';
import 'package:shoesly_ps/gen/assets.gen.dart';

class CustomColorContainer extends StatelessWidget {
  const CustomColorContainer({
    super.key,
    required this.size,
    required this.color,
    required this.isSelected,
  });

  final double size;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: isSelected
          ? Center(
              child: AssetsHelper.svgTickIcon.svg(),
            )
          : null,
    );
  }
}
