import 'package:flutter/material.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';
import 'package:shoesly_ps/src/core/themes/theme.dart';
import 'package:shoesly_ps/src/core/themes/typography/app_text_theme.dart';
import 'package:shoesly_ps/src/core/widgets/custom_data_fetching_loader.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.loader = const CustomDataFetchingLoader(),
    this.loading = false,
    this.buttonColor = AppColors.white,
    this.foregroundColor = Colors.black,
    this.borderSide,
    this.textStyle,
    this.maximumSize = _defaultMaximumSize,
    this.minimumSize = _defaultMinimumSize,
    this.padding = _defaultPadding,
    this.shape = const StadiumBorder(),
    this.enabled = true,
    this.height = 43,
    this.borderColor = AppColors.transparent,
    this.disabledButtonColor = AppColors.grey,
    this.fullWidth = true,
    this.icon,
  });

  const AppButton.black({
    required this.label,
    required this.onPressed,
    super.key,
    this.loader = const CustomDataFetchingLoader(),
    this.loading = false,
    this.buttonColor = AppColors.textBlack,
    this.foregroundColor = Colors.black,
    this.borderSide,
    this.textStyle,
    this.maximumSize = _defaultMaximumSize,
    this.minimumSize = _defaultMinimumSize,
    this.padding = _defaultPadding,
    this.shape = const StadiumBorder(),
    this.enabled = true,
    this.height = 43,
    this.borderColor = AppColors.transparent,
    this.disabledButtonColor = AppColors.grey,
    this.fullWidth = true,
    this.icon,
  });

  const AppButton.white({
    required this.label,
    required this.onPressed,
    super.key,
    this.loader = const CustomDataFetchingLoader(),
    this.loading = false,
    this.buttonColor = AppColors.white,
    this.foregroundColor = Colors.black,
    this.borderSide,
    this.textStyle,
    this.maximumSize = _defaultMaximumSize,
    this.minimumSize = _defaultMinimumSize,
    this.padding = _defaultPadding,
    this.shape = const StadiumBorder(),
    this.enabled = true,
    this.height = 43,
    this.borderColor = AppColors.greyContainer,
    this.disabledButtonColor = AppColors.grey,
    this.fullWidth = true,
    this.icon,
  });

  /// The maximum size of the button.
  static const _defaultMaximumSize = Size(double.infinity, 56);

  /// The minimum size of the button.
  static const _defaultMinimumSize = Size(148, 50);

  /// The padding of the the button.
  static const _defaultPadding = EdgeInsets.all(8);

  /// A background color of the button.
  ///
  /// Defaults to [Colors.white].
  final Color buttonColor;

  /// Color of the text, icons etc.
  ///
  /// Defaults to [Colors.white].
  final Color foregroundColor;

  /// A border of the button.
  final BorderSide? borderSide;

  /// [TextStyle] of the button text.
  final TextStyle? textStyle;

  /// The maximum size of the button.
  ///
  /// Defaults to [_defaultMaximumSize].
  final Size maximumSize;

  /// The minimum size of the button.
  ///
  /// Defaults to [_defaultMinimumSize].
  final Size minimumSize;

  /// The padding of the button.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets padding;

  /// shape for rounded corner button
  final OutlinedBorder shape;

  /// label for button
  final String label;

  /// loader for loading state
  final Widget loader;

  /// flags for loading state
  final bool loading;

  /// onPressed callback
  final VoidCallback onPressed;

  final bool enabled;
  final double height;

  final Color borderColor;
  final Color disabledButtonColor;
  final bool fullWidth;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = textStyle ?? Theme.of(context).textTheme.labelMedium;
    final enabledButtonShape = RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.circular(36),
    );

    final disabledButtonShape = RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.circular(36),
      side: const BorderSide(color: AppColors.greyContainer),
    );

    final enabledButtonStyle = ButtonStyle(
      maximumSize: WidgetStatePropertyAll(maximumSize),
      padding: WidgetStatePropertyAll(padding),
      minimumSize:
          WidgetStatePropertyAll(fullWidth ? maximumSize : minimumSize),
      textStyle: WidgetStatePropertyAll(effectiveStyle),
      backgroundColor: WidgetStatePropertyAll(buttonColor),
      foregroundColor: WidgetStatePropertyAll(foregroundColor),
      side: WidgetStatePropertyAll(borderSide),
      shape: WidgetStatePropertyAll(enabledButtonShape),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
      overlayColor: WidgetStatePropertyAll(
        foregroundColor.withOpacity(0.12),
      ),
    );

    final disabledButtonStyle = ButtonStyle(
      maximumSize: WidgetStatePropertyAll(maximumSize),
      padding: WidgetStatePropertyAll(padding),
      minimumSize:
          WidgetStatePropertyAll(fullWidth ? maximumSize : minimumSize),
      textStyle: WidgetStatePropertyAll(effectiveStyle),
      backgroundColor: WidgetStatePropertyAll(disabledButtonColor),
      side: WidgetStatePropertyAll(borderSide),
      shape: WidgetStatePropertyAll(disabledButtonShape),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
      overlayColor: WidgetStatePropertyAll(foregroundColor.withOpacity(0.12)),
    );

    return Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: borderColor),
        ),
        child: icon == null
            ? FilledButton(
                onPressed: loading || !enabled ? null : onPressed,
                style: enabled ? enabledButtonStyle : disabledButtonStyle,
                child: loading
                    ? loader
                    : Text(
                        label,
                        style: textStyle ??
                            AppTextTheme.displaySmall.copyWith(
                              color: AppColors.white,
                            ),
                      ),
              )
            : FilledButton.icon(
                onPressed: loading || !enabled ? null : onPressed,
                style: enabled ? enabledButtonStyle : disabledButtonStyle,
                label: loading
                    ? loader
                    : Text(
                        label,
                        style: textStyle ??
                            AppTextTheme.displaySmall.copyWith(
                              color: AppColors.white,
                            ),
                      ),
                icon: icon,
              ));
  }
}
