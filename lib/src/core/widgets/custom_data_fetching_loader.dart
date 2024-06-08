import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shoesly_ps/src/core/extensions/context_extensions.dart';

import '../themes/app_colors.dart';

class CustomDataFetchingLoader extends StatelessWidget {
  const CustomDataFetchingLoader({
    super.key,
    this.isCentered = true,
    this.strokeWidth = 4.0,
    this.size,
  });

  final bool isCentered;
  final double strokeWidth;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: isCentered ? (context.height * (size ?? 7.r)) : null,
        width: isCentered ? (context.height * (size ?? 7.r)) : null,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.textBlack,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}
