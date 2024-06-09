import 'package:flutter/material.dart';
import 'package:shoesly_ps/gen/assets.gen.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        14,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: AssetsHelper.svgBackArrow.svg(
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
