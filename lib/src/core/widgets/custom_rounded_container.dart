import 'package:flutter/material.dart';

class CustomRoundedContainer extends StatelessWidget {
  const CustomRoundedContainer({
    super.key,
    required this.borderRadius,
    required this.height,
    required this.width,
    this.child,
    this.backgroundColor,
    this.padding,
  });

  final Widget? child;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final double height;
  final double width;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
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
