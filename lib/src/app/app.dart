import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shoesly_ps/src/core/di/injector.dart';
import 'package:shoesly_ps/src/core/router/app_router.dart';
import 'package:shoesly_ps/src/core/themes/app_theme.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _MaterialApp();
  }
}

class _MaterialApp extends StatelessWidget {
  const _MaterialApp();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 872),
      child: MaterialApp.router(
        theme: AppTheme.appTheme,
        debugShowCheckedModeBanner: false,
        title: 'Shoesly',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        routeInformationParser: getIt<AppRouter>().defaultRouteParser(),
        routerDelegate: AutoRouterDelegate(
          getIt<AppRouter>(),
        ),
      ),
    );
  }
}
