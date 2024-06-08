import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';
import 'package:shoesly_ps/src/core/themes/typography/typography.dart';

abstract class AppTextTheme {
  static final baseTextStyle = GoogleFonts.urbanist(
    decoration: TextDecoration.none,
    fontWeight: AppFontWeight.regular,
    textBaseline: TextBaseline.alphabetic,
    color: AppColors.textBlack,
  );

  static final buttonTextStyle = GoogleFonts.urbanist(
    decoration: TextDecoration.none,
    fontWeight: AppFontWeight.semiBold,
    textBaseline: TextBaseline.alphabetic,
    color: AppColors.white,
  );

  /// display large
  static final TextStyle displayLarge = baseTextStyle.copyWith(
    fontSize: 60,
    height: 64 / 57,
    fontWeight: AppFontWeight.bold,
  );

  /// display medium
  static final TextStyle displayMedium = baseTextStyle.copyWith(
    fontSize: 30,
    height: 52 / 45,
    fontWeight: AppFontWeight.bold,
  );

  /// display small
  static final TextStyle displaySmall = baseTextStyle.copyWith(
    fontSize: 20,
    height: 44 / 36,
    fontWeight: AppFontWeight.bold,
  );

  /// headline large
  static final TextStyle headlineLarge = baseTextStyle.copyWith(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: AppFontWeight.bold,
  );

  /// headline medium
  static final TextStyle headlineMedium = baseTextStyle.copyWith(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: AppFontWeight.bold,
  );

  /// headline small
  static final TextStyle headlineSmall = baseTextStyle.copyWith(
    fontSize: 20,
    height: 32 / 24,
    fontWeight: AppFontWeight.bold,
  );

  /// title large
  static final TextStyle titleLarge = baseTextStyle.copyWith(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: AppFontWeight.bold,
  );

  /// title medium
  static final TextStyle titleMedium = baseTextStyle.copyWith(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.15,
    fontWeight: AppFontWeight.semiBold,
  );

  /// title small
  static final TextStyle titleSmall = baseTextStyle.copyWith(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.1,
    fontWeight: AppFontWeight.bold,
  );

  /// label large
  static final TextStyle labelLarge = buttonTextStyle.copyWith(
    fontSize: 16,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  /// label medium
  static final TextStyle labelMedium = buttonTextStyle.copyWith(
    fontSize: 14,
    height: 16 / 12,
    letterSpacing: 0.5,
    fontWeight: AppFontWeight.medium,
  );

  /// label small
  static final TextStyle labelSmall = buttonTextStyle.copyWith(
    fontSize: 11,
    height: 16 / 11,
    letterSpacing: 0.5,
    fontWeight: AppFontWeight.medium,
  );

  /// body large
  static final TextStyle bodyLarge = baseTextStyle.copyWith(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.5,
  );

  /// body medium
  static final TextStyle bodyMedium = baseTextStyle.copyWith(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.25,
  );

  /// body small
  static final TextStyle bodySmall = baseTextStyle.copyWith(
    fontSize: 12,
    height: 15 / 12,
    letterSpacing: 0.4,
  );

  static TextTheme light(ColorScheme lightColorScheme) {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
    ).apply(
      displayColor: AppColors.textBlack,
    );
  }
}
