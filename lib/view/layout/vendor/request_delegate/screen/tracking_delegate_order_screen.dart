import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../../helpers/utils/date_methods.dart';
import '../../../../../helpers/utils/url_launcher_methods.dart';
import '../../../../custom_widgets/api_response_widget/api_response_widget.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../global/chat/screen/chat_screen.dart';
import '../../../../global/map/utils/map_services.dart';
import '../../../../global/widget/connect_support_widget.dart';
import '../controller/request_delegate_controller.dart';

class TrackingDelegateOrderArgs {
  final int id;
  final VoidCallback? onSuccess;
  TrackingDelegateOrderArgs({required this.id, this.onSuccess});
}

class TrackingDelegateOrderScreen extends StatefulWidget {
  final TrackingDelegateOrderArgs args;
  static const routeName = 'TrackingDelegateOrderScreen';
  const TrackingDelegateOrderScreen({super.key, required this.args});
  @override
  State<TrackingDelegateOrderScreen> createState() => _TrackingDelegateOrderScreenState();
}

class _TrackingDelegateOrderScreenState extends State<TrackingDelegateOrderScreen> {
  late RequestDelegateController requestDelegateController;
  late MapServices mapServices;
  LatLng? origin;
  LatLng? destination;
  late GoogleMapController googleMapController;
  String? _mapStyle;

  Set<Polyline> polyLines = {};
  Set<Marker> markers = {};
  bool isMapReady = false; // New flag for checking if map is ready

  void initMapStyle() async {
    var mapStyle = await DefaultAssetBundle.of(context).loadString('assets/map_styles/dark_map_style.json');
    setState(() {
      _mapStyle = mapStyle;
    });
  }

  @override
  void initState() {
    initMapStyle();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestDelegateController = Provider.of<RequestDelegateController>(context, listen: false);
      Provider.of<RequestDelegateController>(context, listen: false).initialDelegateOrderDetails();

      Provider.of<RequestDelegateController>(context, listen: false).getDelegateOrderDetails(id: widget.args.id).then((
        value,
      ) async {
        mapServices = MapServices();

        // Set origin and destination
        origin = LatLng(
          double.parse(requestDelegateController.delegateOrderDetails?.fromLat ?? '0.0'),
          double.parse(requestDelegateController.delegateOrderDetails?.fromLng ?? '0.0'),
        );
        destination = LatLng(
          double.parse(requestDelegateController.delegateOrderDetails?.toLat ?? '0.0'),
          double.parse(requestDelegateController.delegateOrderDetails?.toLng ?? '0.0'),
        );

        // Ensure the coordinates are valid before proceeding
        if (origin!.latitude != 0.0 && destination!.latitude != 0.0) {
          // Get the polyline points
          // var points = await mapServices.getRouteData(
          //   originFrom: origin!,
          //   desintation: destination!,
          // );

          // Add polyline for the route
          setState(() {
            // polyLines.add(
            //   Polyline(
            //     polylineId: const PolylineId('route'),
            //     points: points,
            //     color: Colors.orange,
            //     width: 5,
            //   ),
            // );

            // Add markers for origin and destination
            markers.add(Marker(markerId: const MarkerId('origin'), position: origin!));
            markers.add(Marker(markerId: const MarkerId('destination'), position: destination!));
            setState(() {});
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          widget.args.onSuccess?.call();
        }
      },
      child: Consumer<RequestDelegateController>(
        builder: (context, requestDelegateController, _) {
          // If origin or destination are null, show a loading indicator
          if (origin == null || destination == null) {
            return const Center(
              child: CircularProgressIndicator(), // Or any other loading widget
            );
          }

          return ApiResponseWidget(
            apiResponse: requestDelegateController.delegateOrderDetailsApiResponse,
            onReload: () => requestDelegateController.getDelegateOrderDetails(id: widget.args.id),
            isEmpty: requestDelegateController.delegateOrderDetails == null,
            child: Container(
              color: AppColor.blackColor(context),
              child: Scaffold(
                backgroundColor: AppColor.blackColor(context),
                appBar: CustomAppBar(
                  appBarColor: AppColor.blackColor(context),
                  context,
                  title: Text(
                    DateMethods.formatDateToArabic(requestDelegateController.delegateOrderDetails?.createdAt ?? ''),
                    style: AppTextStyle.text18BS(context).copyWith(color: AppColor.whiteColor(context)),
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              _buildMap(),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const CustomImage(path: AppImages.radioToIcon, type: ImageType.svg),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      requestDelegateController.delegateOrderDetails?.fromAddress ?? '',
                                      style: AppTextStyle.text16MS(
                                        context,
                                      ).copyWith(color: AppColor.whiteColor(context)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const CustomImage(path: AppImages.radioFromIcon, type: ImageType.svg),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      requestDelegateController.delegateOrderDetails?.toAddress ?? '',
                                      style: AppTextStyle.text16MS(
                                        context,
                                      ).copyWith(color: AppColor.whiteColor(context)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (requestDelegateController.delegateOrderDetails?.delegateId != null) ...[
                                Divider(color: AppColor.darkGreyColor(context)),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    CustomImage(
                                      path: requestDelegateController.delegateOrderDetails?.delegateLogo == null
                                          ? AppImages.delegateRDIcon
                                          : requestDelegateController.delegateOrderDetails?.delegateLogo ?? '',
                                      type: requestDelegateController.delegateOrderDetails?.delegateLogo == null
                                          ? ImageType.svg
                                          : ImageType.network,
                                      width: 45,
                                      height: 45,
                                      radius: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        requestDelegateController.delegateOrderDetails?.delegateName ?? '',
                                        style: AppTextStyle.text16MS(
                                          context,
                                        ).copyWith(color: AppColor.whiteColor(context)),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        UrlLauncherMethods.makePhoneCall(
                                          requestDelegateController.delegateOrderDetails?.delegateMobile ?? '',
                                        );
                                      },
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: AppColor.whiteColor(context),
                                          child: CustomImage(
                                            path: AppImages.callIcon,
                                            type: ImageType.svg,
                                            color: AppColor.blackColor(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        NamedNavigatorImpl.pushNamed(
                                          context,
                                          ChatScreen.routeName,
                                          arguments: ChatScreenArgs(
                                            senderDeviceToken:
                                                requestDelegateController.delegateOrderDetails?.userFcmId ?? '',
                                            accountType: 'vendor',
                                            isVendor: false,
                                            vendorDeviceToken: requestDelegateController
                                                    .delegateOrderDetails?.resturantVendorDeviceToken ??
                                                '',
                                            receiverDeviceToken:
                                                requestDelegateController.delegateOrderDetails?.delegateFcmId ?? '',
                                            senderName: requestDelegateController.delegateOrderDetails?.userName ?? '',
                                            receiverName:
                                                requestDelegateController.delegateOrderDetails?.delegateName ?? '',
                                            orderId: "VD${requestDelegateController.delegateOrderDetails?.id ?? ""}",
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: AppColor.whiteColor(context),
                                          child: CustomImage(
                                            path: AppImages.chatIcon,
                                            type: ImageType.svg,
                                            color: AppColor.blackColor(context),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 10),
                              Divider(color: AppColor.darkGreyColor(context)),
                              const SizedBox(height: 10),
                              Text(
                                AppLocaleKey.orderDetails.tr(),
                                style: AppTextStyle.text16MS(context).copyWith(color: AppColor.whiteColor(context)),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                requestDelegateController.delegateOrderDetails?.description ?? '',
                                style: AppTextStyle.text16MS(context).copyWith(color: AppColor.whiteColor(context)),
                              ),
                              const SizedBox(height: 10),
                              Divider(color: AppColor.darkGreyColor(context)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocaleKey.deliverCost.tr(),
                                    style: AppTextStyle.text16MS(context).copyWith(color: AppColor.whiteColor(context)),
                                  ),
                                  Text(
                                    AppLocaleKey.pound.tr().replaceAll(
                                          '{}',
                                          '${requestDelegateController.delegateOrderDetails?.actualPrice}',
                                        ),
                                    style: AppTextStyle.text16MS(context).copyWith(color: AppColor.whiteColor(context)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Text(
                                      AppLocaleKey.paymentMethod.tr(),
                                      style: AppTextStyle.text16BS(
                                        context,
                                      ).copyWith(color: AppColor.whiteColor(context)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 24,
                                    width: 5,
                                    decoration: BoxDecoration(
                                      color: AppColor.mainAppColor(context),
                                      borderRadius: BorderRadius.horizontal(
                                        left: context.locale.languageCode == 'ar'
                                            ? const Radius.circular(5)
                                            : const Radius.circular(0),
                                        right: context.locale.languageCode == 'ar'
                                            ? const Radius.circular(0)
                                            : const Radius.circular(5),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  CustomImage(
                                    height: 18,
                                    path: requestDelegateController.delegateOrderDetails?.paymentType == 'cash'
                                        ? AppImages.cashIcon
                                        : requestDelegateController.delegateOrderDetails?.paymentType == 'online'
                                            ? AppImages.visaIcon
                                            : requestDelegateController.delegateOrderDetails?.paymentType == 'v_cash'
                                                ? AppImages.vfCash
                                                : requestDelegateController.delegateOrderDetails?.paymentType ==
                                                        'wallet'
                                                    ? AppImages.payWalletIcon.tr()
                                                    : '',
                                    type: ImageType.svg,
                                    color: AppColor.mainAppColor(context),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    requestDelegateController.delegateOrderDetails?.paymentType == 'cash'
                                        ? AppLocaleKey.cash.tr()
                                        : requestDelegateController.delegateOrderDetails?.paymentType == 'online'
                                            ? AppLocaleKey.visa.tr()
                                            : requestDelegateController.delegateOrderDetails?.paymentType == 'v_cash'
                                                ? AppLocaleKey.vfCash.tr()
                                                : requestDelegateController.delegateOrderDetails?.paymentType ==
                                                        'wallet'
                                                    ? AppLocaleKey.appWallet.tr()
                                                    : '',
                                    style: AppTextStyle.text16BM(context),
                                  ),
                                ],
                              ),
                              if (requestDelegateController.delegateOrderDetails?.status == 'accepted')
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: CustomButton(
                                    text: AppLocaleKey.cancelOrder.tr(),
                                    onPressed: () {
                                      requestDelegateController.cancelOrder(
                                        orderId: requestDelegateController.delegateOrderDetails!.id!,
                                        onSuccess: () {
                                          NamedNavigatorImpl.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const ConnectSupportWidget(isDark: true),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ClipRRect _buildMap() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: origin!, // Use the origin as the target
            zoom: 16,
          ),
          zoomControlsEnabled: false,
          markers: markers,
          polylines: polyLines,
          style: _mapStyle,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
            // googleMapController.setMapStyle(_mapStyle);
            markers.add(Marker(markerId: const MarkerId('origin'), position: origin!));

            markers.add(Marker(markerId: const MarkerId('destination'), position: destination!));

            setState(() {
              isMapReady = true; // Set flag when map is ready
            });

            // Update the camera to show both origin and destination
            googleMapController.animateCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: LatLng(
                    origin!.latitude < destination!.latitude ? origin!.latitude : destination!.latitude,
                    origin!.longitude < destination!.longitude ? origin!.longitude : destination!.longitude,
                  ),
                  northeast: LatLng(
                    origin!.latitude > destination!.latitude ? origin!.latitude : destination!.latitude,
                    origin!.longitude > destination!.longitude ? origin!.longitude : destination!.longitude,
                  ),
                ),
                100.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
