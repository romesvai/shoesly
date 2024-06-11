import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shoesly_ps/src/core/constants/number_constants.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';

class CustomRangeSlideThemeWidget extends StatelessWidget {
  const CustomRangeSlideThemeWidget({
    super.key,
    required this.slider,
  });

  final Widget slider;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: sliderTrackHeight.toDouble(),
        trackShape: const RoundedRectSliderTrackShape(),
        rangeThumbShape: CustomRangeSliderThumbShape(),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: slider,
    );
  }
}

class CustomRangeSliderThumbShape implements RangeSliderThumbShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(13.r);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;
    Path innerCirclePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: 8.r))
      ..fillType = PathFillType.evenOdd;
    Path outerCirclePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: 15.r))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(outerCirclePath, Paint()..color = AppColors.textBlack);
    canvas.drawPath(innerCirclePath, Paint()..color = AppColors.white);
  }
}
