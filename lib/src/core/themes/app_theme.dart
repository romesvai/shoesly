import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';
import 'package:shoesly_ps/src/core/themes/typography/app_text_theme.dart';

const _colorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.homeAppBar,
  onPrimary: Color(0xFF003350),
  primaryContainer: Color(0xFF004B72),
  onPrimaryContainer: Color(0xFFCCE5FF),
  secondary: Color(0xFFB8C8D9),
  onSecondary: Color(0xFF23323F),
  secondaryContainer: Color(0xFF394856),
  onSecondaryContainer: Color(0xFFD4E4F6),
  tertiary: Color(0xFFD1BFE7),
  onTertiary: Color(0xFF372A4A),
  tertiaryContainer: Color(0xFF4E4162),
  onTertiaryContainer: Color(0xFFECDCFF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: AppColors.background,
  onBackground: Color(0xFFE2E2E5),
  surface: Color(0xFF1A1C1E),
  onSurface: Color(0xFFC6C6C9),
  surfaceVariant: Color(0xFF42474E),
  onSurfaceVariant: Color(0xFFC2C7CE),
  outline: Color(0xFF8C9198),
  onInverseSurface: Color(0xFF1A1C1E),
  inverseSurface: Color(0xFFE2E2E5),
  inversePrimary: Color(0xFF006496),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF91CDFF),
  outlineVariant: Color(0xFF42474E),
  scrim: Color(0xFF000000),
);

abstract class AppTheme {
  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
    ),
  );
  static final _filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: const StadiumBorder(),
    ),
  );

  static const _floatingActionButtonTheme = FloatingActionButtonThemeData(
    shape: CircleBorder(),
  );

  static const _navigationBarTheme = NavigationBarThemeData(
    backgroundColor: AppColors.background,
  );

  static TextTheme get _appTextTheme => AppTextTheme.light(_colorScheme);

  static final _darkInputTheme = InputDecorationTheme(
    labelStyle:
        _appTextTheme.bodySmall?.copyWith(color: _colorScheme.onSurfaceVariant),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(44)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(44)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(44)),
    focusedErrorBorder:
        OutlineInputBorder(borderRadius: BorderRadius.circular(44)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(44)),
    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(44)),
    outlineBorder: BorderSide.none,
    constraints: const BoxConstraints(minHeight: 44),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    alignLabelWithHint: true,
  );

  static ThemeData get appTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.dark,
        colorScheme: _colorScheme,
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: _appTextTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        inputDecorationTheme: _darkInputTheme,
        filledButtonTheme: _filledButtonTheme,
        floatingActionButtonTheme: _floatingActionButtonTheme,
        navigationBarTheme: _navigationBarTheme,
        textSelectionTheme:
            TextSelectionThemeData(cursorColor: _colorScheme.primary),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.background,
          surfaceTintColor: _colorScheme.primary,
          titleTextStyle: _appTextTheme.titleMedium,
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: AppColors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        splashColor: AppColors.transparent,
      );
}
