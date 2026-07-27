import 'package:bot_toast/bot_toast.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helpers/pusher_service/pusher_controller.dart';
import 'helpers/routes/app_routers_import.dart';
import 'helpers/theme/style.dart';
import 'helpers/utils/route_obs.dart';
import 'view/global/chat/controller/admin_chat_controller.dart';
import 'view/global/chat/controller/chat_controller.dart';
import 'view/layout/vendor/auth/controller/auth_controller.dart';
import 'view/layout/vendor/auth/on_boarding/screen/splash_screen.dart';
import 'view/layout/vendor/home/controller/home_vendor_controller.dart';
import 'view/layout/vendor/order/controller/order_controller.dart';
import 'view/layout/vendor/products/controller/product_controller.dart';
import 'view/layout/vendor/request_delegate/controller/request_delegate_controller.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setMyAppState(BuildContext context) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setMyAppState();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  void setMyAppState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => HomeVendorController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => RequestDelegateController()),
        ChangeNotifierProvider(create: (_) => AdminChatController()),
        ChangeNotifierProvider(create: (_) => PusherController()),
      ],
      child: MaterialApp(
        title: 'FasakhaNinja Vendor',
        localizationsDelegates: [...context.localizationDelegates, CountryLocalizations.delegate],
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: appThemeData(context),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver(), AppRouteObserver()],
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: NamedNavigatorImpl.onGenerateRoute,
        navigatorKey: NamedNavigatorImpl.navigatorState,
      ),
    );
  }
}
