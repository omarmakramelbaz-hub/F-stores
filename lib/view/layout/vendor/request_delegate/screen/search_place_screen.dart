import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/routes/app_routers_import.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../../helpers/images/app_images.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../../../custom_widgets/buttons/custom_button.dart';
import '../../../../custom_widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../custom_widgets/custom_form_field/custom_form_field.dart';
import '../../../../custom_widgets/custom_image/custom_image.dart';
import '../../../../global/map/model/place_autocomplete_model/place_autocomplete_model.dart';
import '../../../../global/map/utils/google_maps_place_service.dart';
import '../../../../global/map/utils/map_services.dart';
import '../controller/request_delegate_controller.dart';
import '../widget/custom_list_view.dart';
import 'select_location_from_map_screen.dart';

class SearchPlaceScreen extends StatefulWidget {
  static const routeName = 'SearchPlaceScreen';

  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final fromFocusNode = FocusNode();
  final toFocusNode = FocusNode();
  final focusNode = FocusNode();

  late PlacesService googleMapsPlaceService;
  // late GoogleMapController googleMapController;
  late MapServices mapServices;
  Timer? debounce;
  String? sesstionToken;

  late LatLng origin;
  late LatLng desintation;
  late Uuid uuid;
  List<PlaceModel> fromPlaces = [];
  List<PlaceModel> toPlaces = [];
  Set<Polyline> polyLines = {};

  late RequestDelegateController requestDelegateController;
  bool isFromFieldFocused = false;
  bool isToFieldFocused = false;
  // LatLng? fromLatLng;
  // LatLng? toLatLng;

  @override
  initState() {
    requestDelegateController = Provider.of<RequestDelegateController>(context, listen: false);

    requestDelegateController.fromController.addListener(() {
      fetchFromPredictions();
    });
    requestDelegateController.toController.addListener(() {
      fetchToPredictions();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fromController.text = context.read<RequestDelegateController>().fromAddress;
      fetchFromPredictions(); // Call initially to load data if needed
      fetchToPredictions(); // Call initially to load data if needed
    });
    mapServices = MapServices();
    uuid = const Uuid();
    fetchFromPredictions();
    fetchToPredictions();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Safe to access Provider here
    requestDelegateController = Provider.of<RequestDelegateController>(context);

    // Set initial value if needed
    fromController.text = requestDelegateController.fromAddress;

    // Add listeners to controllers
    requestDelegateController.fromController.addListener(fetchFromPredictions);
    requestDelegateController.toController.addListener(fetchToPredictions);
  }

  // Fetch predictions for the "From" field
  void fetchFromPredictions() {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }

    debounce = Timer(const Duration(milliseconds: 100), () async {
      // Check if mounted before proceeding
      if (!mounted) return;

      sesstionToken ??= uuid.v4();
      // Only use context when mounted
      await mapServices.getPredictions(
        input: requestDelegateController.fromController.text,
        sesstionToken: sesstionToken!,
        places: fromPlaces,
      );

      // Only call setState if mounted
      if (mounted) {
        setState(() {});
      }
    });
  }

  void fetchToPredictions() {
    if (debounce?.isActive ?? false) {
      debounce?.cancel();
    }

    debounce = Timer(const Duration(milliseconds: 100), () async {
      // Check if mounted before proceeding
      if (!mounted) return;

      sesstionToken ??= uuid.v4();
      // Only use context when mounted
      await mapServices.getPredictions(
        input: requestDelegateController.toController.text,
        sesstionToken: sesstionToken!,
        places: toPlaces,
      );

      // Only call setState if mounted
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    debounce?.cancel(); // Cancel any active debounce Timer

    // Remove the listeners to prevent errors
    requestDelegateController.fromController.removeListener(fetchFromPredictions);
    requestDelegateController.toController.removeListener(fetchToPredictions);

    // Dispose controllers and focus nodes
    fromController.dispose();
    toController.dispose();
    fromFocusNode.dispose();
    toFocusNode.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestDelegateController>(
      builder: (context, requestDelegateController, _) {
        log(requestDelegateController.fromAddress);

        return Scaffold(
          backgroundColor: AppColor.blackColor(context),
          extendBody: true,
          appBar: CustomAppBar(
            appBarColor: AppColor.blackColor(context),
            radius: 40,
            context,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColor.whiteColor(context)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(AppLocaleKey.chooseDeliveryAddresses.tr()),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Focus(
                    onFocusChange: (hasFocus) {
                      isFromFieldFocused = hasFocus;
                    },
                    child: CustomFormField(
                      fillColor: AppColor.lightDarkColor(context),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: CustomImage(path: AppImages.radioFromIcon, type: ImageType.svg),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          requestDelegateController.fromController.clear();
                          // requestDelegateController.setFromController('');
                        },
                        child: const Icon(Icons.close),
                      ),
                      controller: requestDelegateController.fromController,
                      hintText: AppLocaleKey.from.tr(),
                      textStyle: AppTextStyle.text14MW(context),
                      unFocusColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(
                        context,
                        SelectLocationFromMapScreen.routeName,
                        arguments: SelectLocationFromMapScreenArgs(isFromAddress: true),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.share_location, color: AppColor.mainAppColor(context)),
                        Text(AppLocaleKey.showOnMap.tr(), style: AppTextStyle.text14MM(context)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Focus(
                    onFocusChange: (hasFocus) {
                      isFromFieldFocused = !hasFocus;
                      isToFieldFocused = hasFocus;
                    },
                    child: CustomFormField(
                      fillColor: AppColor.lightDarkColor(context),
                      unFocusColor: AppColor.blackColor(context),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: CustomImage(path: AppImages.radioToIcon, type: ImageType.svg),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          requestDelegateController.toController.clear();
                          // requestDelegateController.setToController('');
                        },
                        child: const Icon(Icons.close),
                      ),
                      controller: requestDelegateController.toController,
                      hintText: AppLocaleKey.to.tr(),
                      textStyle: AppTextStyle.text14MW(context),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      NamedNavigatorImpl.pushNamed(
                        context,
                        SelectLocationFromMapScreen.routeName,
                        arguments: SelectLocationFromMapScreenArgs(isFromAddress: false),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.share_location, color: AppColor.mainAppColor(context)),
                        Text(AppLocaleKey.showOnMap.tr(), style: AppTextStyle.text14MM(context)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (isFromFieldFocused)
                    CustomListView(
                      onPlaceSelect: (placeDetailsModel) async {
                        requestDelegateController.setFromController(placeDetailsModel.formattedAddress ?? '');
                        requestDelegateController.setFromLat(placeDetailsModel.geometry!.location!.lat!.toString());
                        requestDelegateController.setFromLan(placeDetailsModel.geometry!.location!.lng!.toString());

                        requestDelegateController.setFromLatLng(
                          LatLng(
                            placeDetailsModel.geometry!.location!.lat!,
                            placeDetailsModel.geometry!.location!.lng!,
                          ),
                        );

                        fromPlaces.clear();
                        isFromFieldFocused = false;
                        sesstionToken = null;
                        setState(() {});
                      },
                      places: isFromFieldFocused ? fromPlaces : toPlaces,
                      mapServices: mapServices,
                    ),
                  if (isToFieldFocused)
                    CustomListView(
                      onPlaceSelect: (placeDetailsModel) async {
                        requestDelegateController.setToController(placeDetailsModel.formattedAddress ?? '');
                        requestDelegateController.setToLat(placeDetailsModel.geometry!.location!.lat!.toString());
                        requestDelegateController.setToLan(placeDetailsModel.geometry!.location!.lng!.toString());

                        requestDelegateController.setToLatLng(
                          LatLng(
                            placeDetailsModel.geometry!.location!.lat!,
                            placeDetailsModel.geometry!.location!.lng!,
                          ),
                        );

                        toPlaces.clear();
                        isToFieldFocused = false;
                        focusNode.unfocus();
                        sesstionToken = null;
                        setState(() {});
                      },
                      places: isFromFieldFocused ? fromPlaces : toPlaces,
                      mapServices: mapServices,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                      text: AppLocaleKey.confirm.tr(),
                      onPressed: () {
                        requestDelegateController.setFromAddress(requestDelegateController.fromController.text);

                        requestDelegateController.setToAddress(requestDelegateController.toController.text);

                        requestDelegateController.setFromLat(
                          requestDelegateController.fromLatLng?.latitude.toString() ??
                              requestDelegateController.fromLat ??
                              '',
                        );

                        requestDelegateController.setFromLan(
                          requestDelegateController.fromLatLng?.longitude.toString() ??
                              requestDelegateController.fromLan ??
                              '',
                        );

                        if (requestDelegateController.fromLatLng != null) {
                          requestDelegateController.setFromLat(
                            requestDelegateController.fromLatLng?.latitude.toString() ??
                                requestDelegateController.fromLan ??
                                '',
                          );

                          requestDelegateController.setFromLan(
                            requestDelegateController.fromLatLng?.longitude.toString() ??
                                requestDelegateController.fromLan ??
                                '',
                          );
                        }

                        if (requestDelegateController.toLatLng != null) {
                          requestDelegateController.setToLat(
                            requestDelegateController.toLatLng?.latitude.toString() ?? '',
                          );
                          requestDelegateController.setToLan(
                            requestDelegateController.toLatLng?.longitude.toString() ?? '',
                          );
                        }

                        // double distance = requestDelegateController.calculateDistance();
                        // log(distance.toString());

                        log(requestDelegateController.fromController.text);
                        log(requestDelegateController.toController.text);
                        log(requestDelegateController.fromLat.toString());
                        log(requestDelegateController.fromLan.toString());
                        log(requestDelegateController.toLat.toString());
                        log(requestDelegateController.toLan.toString());
                        requestDelegateController.calculateDistance(
                          kmPrice: requestDelegateController.delegatesOnMap?.shippingKmPrice ?? 0,
                        );

                        log(requestDelegateController.distance.toString());
                        requestDelegateController.calculateDeliveryPrice(
                          kmPrice: requestDelegateController.delegatesOnMap?.shippingKmPrice ?? 0,
                        );
                        log('km price ${requestDelegateController.delegatesOnMap?.shippingKmPrice ?? 0}');
                        log('distance coast ${requestDelegateController.distance ?? 0}');

                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
