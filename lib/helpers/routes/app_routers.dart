part of 'app_routers_import.dart';

class NamedNavigatorImpl {
  static GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();
  static final BuildContext context = navigatorState.currentContext!;
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    dynamic args;
    if (settings.arguments != null) args = settings.arguments;
    switch (settings.name) {
      case ZoomImageScreen.routeName:
        return _materialRoute(ZoomImageScreen(args: args));
      case SplashScreen.routeName:
        return _materialRoute(const SplashScreen());
      case LoginScreen.routeName:
        return _materialRoute(const LoginScreen());
      case VendorBottomNavigationBarScreen.routeName:
        return _materialRoute(const VendorBottomNavigationBarScreen());
      case ForgetPasswordScreen.routeName:
        return _materialRoute(const ForgetPasswordScreen());
      case VerificationCodeScreen.routeName:
        return _materialRoute(const VerificationCodeScreen());
      case CreateNewPasswordScreen.routeName:
        return _materialRoute(const CreateNewPasswordScreen());
      case PasswordChangedSuccessfullyScreen.routeName:
        return _materialRoute(const PasswordChangedSuccessfullyScreen());

      case HomeVendorScreen.routeName:
        return _materialRoute(const HomeVendorScreen());
      case CurrentOrdersScreen.routeName:
        return _materialRoute(CurrentOrdersScreen(args: args));
      case OrderDetailsScreen.routeName:
        return _materialRoute(OrderDetailsScreen(args: args));

      case AccountInformationScreen.routeName:
        return _materialRoute(const AccountInformationScreen());
      case PersonalInformationScreen.routeName:
        return _materialRoute(const PersonalInformationScreen());
      case ChangePasswordScreen.routeName:
        return _materialRoute(const ChangePasswordScreen());
      case AddProductScreen.routeName:
        return _materialRoute(const AddProductScreen());
      case ProductDetailsScreen.routeName:
        return _materialRoute(ProductDetailsScreen(args: args));
      case AddNewMenuScreen.routeName:
        return _materialRoute(const AddNewMenuScreen());
      case HelpScreen.routeName:
        return _materialRoute(const HelpScreen());
      case PrivacyPolicyScreen.routeName:
        return _materialRoute(const PrivacyPolicyScreen());
      case TermsAndConditionsScreen.routeName:
        return _materialRoute(const TermsAndConditionsScreen());
      case ContactUsScreen.routeName:
        return _materialRoute(const ContactUsScreen());
      case WalletScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => WalletController()
                  ..initialWallet()
                  ..getWallet(),
              ),
              ChangeNotifierProvider(
                create: (_) => MyAccountController()
                  ..initialSetting()
                  ..getSetting(),
              ),
            ],
            child: const WalletScreen(),
          ),
        );
      case MyReportsScreen.routeName:
        return _materialRoute(const MyReportsScreen());

      case VendorLocationScreen.routeName:
        return _materialRoute(const VendorLocationScreen());

      case ChatScreen.routeName:
        return _materialRoute(ChatScreen(args: args));

      case CustomPaymentWebViewScreen.routeName:
        return _materialRoute(CustomPaymentWebViewScreen(args: args));
      case AdminChatScreen.routeName:
        return _materialRoute(AdminChatScreen(args: args));
      case TrackingDelegateOrderScreen.routeName:
        return _materialRoute(TrackingDelegateOrderScreen(args: args));
      case SelectLocationFromMapScreen.routeName:
        return _materialRoute(SelectLocationFromMapScreen(args: args));
      case SearchPlaceScreen.routeName:
        return _materialRoute(const SearchPlaceScreen());
      case ShowDelegateOnMapScreen.routeName:
        return _materialRoute(ShowDelegateOnMapScreen(args: args));
      case RequestDelegateScreen.routeName:
        return _materialRoute(const RequestDelegateScreen());

      case DelegateOrdersScreen.routeName:
        return _materialRoute(const DelegateOrdersScreen());
      case DeliveryLocationScreen.routeName:
        return _materialRoute(DeliveryLocationScreen(args: args));
      case ContractVendorScreen.routeName:
        return _materialRoute(ContractVendorScreen(args: args));
      case RegisterAsVendorScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => MyAccountController(),
            child: RegisterAsVendorScreen(args: args),
          ),
        );
      default:
        return null;
    }
  }

  static MaterialPageRoute<Object?> _materialRoute(Widget screen, {RouteSettings? arguments}) =>
      MaterialPageRoute(builder: (context) => screen, settings: arguments);

  static String? currentRoute;

  static void pushNamed(
    BuildContext context,
    String routeName, {
    dynamic arguments,
    Function(dynamic result)? onReturn,
  }) {
    if (_shouldNavigate(routeName)) {
      Navigator.pushNamed(context, routeName, arguments: arguments).then((result) {
        if (onReturn != null) {
          onReturn(result);
        }
      });
      _updateCurrentRoute(routeName);
    }
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
    currentRoute = null;
  }

  static void pushReplacementNamed(BuildContext context, String routeName, {dynamic arguments}) {
    if (_shouldNavigate(routeName)) {
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
      _updateCurrentRoute(routeName);
    }
  }

  static void pushNamedAndRemoveUntil(BuildContext context, String routeName, {dynamic arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false, arguments: arguments);
    _updateCurrentRoute(routeName);
  }

  static void showAppDialog(BuildContext context, Widget dialog, {bool willPop = true}) {
    showDialog(
      context: context,
      barrierDismissible: willPop,
      builder: (context) {
        return PopScope(canPop: willPop, child: dialog);
      },
    );
  }

  static void showAppBottomSheet(
    BuildContext context,
    Widget bottomSheet, {
    bool willPop = true,
    bool? isScrollControlled,
    bool enableDrag = true,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 0,
      isScrollControlled: isScrollControlled ?? false,
      isDismissible: willPop,
      enableDrag: enableDrag,
      context: context,
      builder: (context) {
        return PopScope(canPop: willPop, child: bottomSheet);
      },
    );
  }

  static void loading({
    double size = 60,
    double radius = 50,
    double loadingSize = 30,
    Color? backgroundColor,
    Color? loadingColor,
  }) {
    FocusScope.of(NamedNavigatorImpl.navigatorState.currentContext!).requestFocus(FocusNode());
    BotToast.showCustomLoading(
      toastBuilder: (cancelFunc) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColor.scaffoldColor(NamedNavigatorImpl.navigatorState.currentContext!),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: CustomLoading(
            color: loadingColor ?? AppColor.mainAppColor(NamedNavigatorImpl.navigatorState.currentContext!),
            size: loadingSize,
          ),
        ),
      ),
    );
  }

  static void loadingOff() {
    BotToast.closeAllLoading();
  }

  static bool _shouldNavigate(String routeName) {
    if (currentRoute == routeName) {
      debugPrint('Already on route: $routeName. Navigation skipped.');
      return false;
    }
    return true;
  }

  static void _updateCurrentRoute(String routeName) {
    currentRoute = routeName;
    debugPrint('Updated current route: $routeName');
  }
}
