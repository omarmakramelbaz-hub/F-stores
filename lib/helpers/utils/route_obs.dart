import 'package:flutter/material.dart';

import '../routes/app_routers_import.dart';

class AppRouteObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    NamedNavigatorImpl.currentRoute = previousRoute?.settings.name ?? '';
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    NamedNavigatorImpl.currentRoute = route.settings.name ?? '';
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    NamedNavigatorImpl.currentRoute = newRoute?.settings.name ?? '';
  }
}
