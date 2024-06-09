import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shoesly_ps/src/core/themes/app_colors.dart';
import 'package:shoesly_ps/src/core/widgets/custom_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.actions,
    this.backgroundColor = AppColors.white,
    this.automaticallyImplyLeading = true,
    this.leading,
  });

  final Widget? title;
  final Widget? leading;
  final bool centerTitle;
  final List<Widget>? actions;
  final Color backgroundColor;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final parentRoute = ModalRoute.of(context);

    Widget? effectiveLeading() {
      if (leading != null) {
        return leading;
      }

      if (automaticallyImplyLeading) {
        if (parentRoute?.impliesAppBarDismissal ?? false) {
          return CustomBackButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
          );
        }
      }
      return null;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        centerTitle: centerTitle,
        backgroundColor: backgroundColor,
        title: title,
        actions: actions,
        leading: effectiveLeading(),
      ),
    );
  }
}
