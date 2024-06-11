import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';

extension ContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  void showSnackBar(
    Widget content, {
    bool hideActive = false,
    bool error = false,
  }) {
    if (hideActive) {
      ScaffoldMessenger.of(this)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: content,
            backgroundColor: error ? AppColors.error : AppColors.success,
          ),
        );
    } else {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: content,
          backgroundColor: error ? AppColors.error : AppColors.success,
        ),
      );
    }
  }
}
