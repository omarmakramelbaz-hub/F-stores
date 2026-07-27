import 'package:easy_localization/easy_localization.dart';
import '../../../helpers/locale/app_locale_key.dart';
import '../../../helpers/utils/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PaymentArgs {
  final String url;
  final VoidCallback onSuccess;
  final VoidCallback onFailed;
  PaymentArgs({required this.url, required this.onSuccess, required this.onFailed});
}

class CustomPaymentWebViewScreen extends StatefulWidget {
  const CustomPaymentWebViewScreen({super.key, required this.args});
  static const routeName = 'CustomPaymentWebViewScreen';
  final PaymentArgs args;

  @override
  State<CustomPaymentWebViewScreen> createState() => _CustomPaymentWebViewScreenState();
}

class _CustomPaymentWebViewScreenState extends State<CustomPaymentWebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  late Uri myUrl;
  late final WebViewController _controller;

  double progress = 0;
  @override
  void initState() {
    late final PlatformWebViewControllerCreationParams params;
    super.initState();
    myUrl = Uri.parse(widget.args.url);

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => setState(() => this.progress = progress / 100),
          onPageStarted: (String url) => debugPrint('Page started loading: $url'),
          onPageFinished: (String url) => debugPrint('Page finished loading: $url'),
          onNavigationRequest: (NavigationRequest request) async {
            final NavigationDecision policy = await _pageRedirect(context, request.url);
            return policy;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            // openDialog(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(myUrl);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  // _exitApp(BuildContext context) async {
  //   _controller.canGoBack().then((value) {
  //     if (value) {
  //       _controller.goBack();
  //     } else {
  //       Navigator.pop(context);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            progress < 1.0
                ? Positioned(top: 0, right: 0, left: 0, child: LinearProgressIndicator(value: progress))
                : Container(),
          ],
        ),
      ),
    );
  }

  // Future<NavigationDecision> _pageRedirect(
  //     BuildContext context, String url) async {
  //       log(url);
  //   //bool isSuccess = url.contains('pay-thanks');
  //   bool isSuccess = url.contains('success=true');
  //   bool isFailed=url.contains('success=flase');
  //  // bool isFailed = url.contains('cancelled-form');
  //   if ( isSuccess) {
  //     Navigator.pop(context, isSuccess);
  //     CommonMethods.showToast(message: AppLocaleKey.paymentSuccessful.tr(),seconds: 5);
  //     widget.args.onSuccess.call();
  //     return NavigationDecision.prevent;
  //  }
  //    else if (isFailed) {
  //     Navigator.pop(context, isSuccess);
  //     CommonMethods.showError(message: 'Payment Failed');
  //     return NavigationDecision.prevent;
  //   }
  //   else {
  //      Navigator.pop(context, isSuccess);
  //     CommonMethods.showError(message: 'Payment Failed',seconds:5 );
  //     return NavigationDecision.navigate;
  //   }
  // }
  Future<NavigationDecision> _pageRedirect(BuildContext context, String url) async {
    bool isSuccess = url.contains('pay-thanks');
    bool isFailed = url.contains('pay-false');
    if (isSuccess) {
      Navigator.pop(context, isSuccess);
      CommonMethods.showToast(message: AppLocaleKey.paymentSuccess.tr());
      widget.args.onSuccess.call();
      return NavigationDecision.prevent;
    } else if (isFailed) {
      Navigator.pop(context, isSuccess);
      CommonMethods.showError(message: AppLocaleKey.paymentFailed.tr());
      widget.args.onFailed.call();
      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate;
    }
  }
}
