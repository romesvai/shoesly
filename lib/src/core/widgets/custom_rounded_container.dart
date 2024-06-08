import 'package:flutter/material.dart';

class CustomRoundedContainer extends StatelessWidget {
  const CustomRoundedContainer({
    super.key,
    required this.borderRadius,
    required this.height,
    required this.width,
    this.child,
    this.backgroundColor,
  });

  final Widget? child;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      height: height,
      width: width,
      child: child,
    );
  }
}
