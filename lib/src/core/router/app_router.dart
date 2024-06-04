import 'package:auto_route/auto_route.dart';
import 'package:shoesly_ps/src/core/router/app_router.dart';

export 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: DiscoverRoute.page,
          initial: true,
        ),
      ];
}
