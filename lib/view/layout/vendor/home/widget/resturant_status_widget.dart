import 'package:easy_localization/easy_localization.dart';
import '../../../../../helpers/locale/app_locale_key.dart';
import '../../../../../helpers/theme/app_colors.dart';
import '../../../../../helpers/theme/app_text_style.dart';
import '../../auth/controller/auth_controller.dart';
import '../../bottom_navigation/controller/bottom_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResturantStatusWidget extends StatefulWidget {
  const ResturantStatusWidget({super.key});

  @override
  State<ResturantStatusWidget> createState() => _ResturantStatusWidgetState();
}

enum ResturantStatus { open, busy, closed }

class _ResturantStatusWidgetState extends State<ResturantStatusWidget> {
  ResturantStatus? selectedStatus;
  final bool isDisabled = false;
  @override
  void initState() {
    super.initState();

    final authController = Provider.of<AuthController>(context, listen: false);

    authController.addListener(() {
      if (mounted) {
        final vendorStatus = authController.profile?.vendorStatus;
        if (vendorStatus != null) {
          setState(() {
            selectedStatus = vendorStatus == 'opened'
                ? ResturantStatus.open
                : vendorStatus == 'busy'
                ? ResturantStatus.busy
                : ResturantStatus.closed;
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initial check if profile is already loaded
      final vendorStatus = authController.profile?.vendorStatus;
      if (vendorStatus != null) {
        setState(() {
          selectedStatus = vendorStatus == 'opened'
              ? ResturantStatus.open
              : vendorStatus == 'busy'
              ? ResturantStatus.busy
              : ResturantStatus.closed;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authController = Provider.of<AuthController>(context);
    final vendorStatus = authController.profile?.vendorStatus;
    if (vendorStatus != null && selectedStatus == null) {
      setState(() {
        selectedStatus = vendorStatus == 'opened'
            ? ResturantStatus.open
            : vendorStatus == 'busy'
            ? ResturantStatus.busy
            : ResturantStatus.closed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AuthController>(context).profile?.vendorStatus == 'disabled') {
      return const SizedBox();
    } else {
      return ChangeNotifierProvider(
        create: (context) => VendorBottomNavigationController(),
        child: Consumer<VendorBottomNavigationController>(
          builder: (context, vendorBottomNavigationController, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocaleKey.resturantStatus.tr(), style: AppTextStyle.text18BS(context)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: AppColor.ecececColor(context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusButton(ResturantStatus.open, AppLocaleKey.open, vendorBottomNavigationController),
                      _buildStatusButton(ResturantStatus.busy, AppLocaleKey.busy, vendorBottomNavigationController),
                      _buildStatusButton(ResturantStatus.closed, AppLocaleKey.closed, vendorBottomNavigationController),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  Widget _buildStatusButton(
    ResturantStatus status,
    String label,
    VendorBottomNavigationController vendorBottomNavigationController,
  ) {
    final isSelected = selectedStatus == status;
    return InkWell(
      onTap: () {
        setState(() => selectedStatus = status);
        vendorBottomNavigationController.changeStatusOnline(
          id: context.read<AuthController>().profile?.resturantId ?? 0,
          status: status == ResturantStatus.closed
              ? 'closed'
              : status == ResturantStatus.open
              ? 'opened'
              : 'busy',
          onSuccess: () {
            Provider.of<AuthController>(context, listen: false).getProfile();
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.mainAppColor(context) : null,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(label.tr(), style: isSelected ? AppTextStyle.text14MW(context) : AppTextStyle.text14MS(context)),
      ),
    );
  }
}
