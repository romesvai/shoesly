import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';

class CustomShimmerWidget extends StatelessWidget {
  const CustomShimmerWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyContainer,
      highlightColor: AppColors.white,
      child: child,
    );
  }
}
