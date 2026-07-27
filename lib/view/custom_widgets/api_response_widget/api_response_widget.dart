import 'package:flutter/material.dart';

import '../../../helpers/networking/api_helper.dart';
import '../custom_loading/custom_loading.dart';
import '../exception_widget/exception_widget.dart';
import '../no_data_widget/no_data_widget.dart';
import '../offline_widget/offline_widget.dart';

class ApiResponseWidget extends StatelessWidget {
  final ApiResponse apiResponse;
  final Widget child;
  final double loadingSize;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final Widget? unauthorizedWidget;
  final Widget? offlineWidget;
  final bool isEmpty;
  final bool initialChild;
  final void Function()? onReload;
  final Axis axis;
  final String? noDataMessage;
  final String? exceptionMessage;
  final Color? loadingColor;
  const ApiResponseWidget({
    super.key,
    required this.apiResponse,
    required this.child,
    required this.onReload,
    required this.isEmpty,
    this.loadingSize = 35,
    this.loadingWidget,
    this.axis = Axis.vertical,
    this.noDataMessage,
    this.exceptionMessage,
    this.errorWidget,
    this.emptyWidget,
    this.offlineWidget,
    this.loadingColor,
    this.unauthorizedWidget,
    this.initialChild = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (apiResponse.state) {
      case ResponseState.sleep:
        if (initialChild) {
          return child;
        } else {
          return const SizedBox();
        }
      case ResponseState.loading:
        return loadingWidget ??
            Center(
              child: CustomLoading(size: loadingSize, color: loadingColor),
            );
      case ResponseState.complete:
      case ResponseState.pagination:
        if (isEmpty) {
          return emptyWidget ??
              Center(
                child: NoDataWidget(message: noDataMessage, axis: axis),
              );
        } else {
          return child;
        }
      case ResponseState.error:
        return errorWidget ??
            Center(
              child: ExceptionWidget(message: exceptionMessage, axis: axis, onReload: onReload),
            );
      case ResponseState.unauthorized:
        return unauthorizedWidget ??
            Center(
              child: ExceptionWidget(message: exceptionMessage, axis: axis, onReload: onReload),
            );
      case ResponseState.offline:
        return offlineWidget ??
            Center(
              child: OfflineWidget(axis: axis, onReload: onReload),
            );
    }
  }
}
