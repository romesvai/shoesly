import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';

class CustomRatingsBar extends StatelessWidget {
  const CustomRatingsBar({
    super.key,
    required this.ratingValue,
  });

  final double ratingValue;

  @override
  Widget build(BuildContext context) {
    return RatingStars(
      value: ratingValue,
      valueLabelVisibility: false,
      starSize: 12,
      starColor: AppColors.starColor,
    );
  }
}
