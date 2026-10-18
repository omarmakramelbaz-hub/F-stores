import 'dart:async';

import '../../../../../helpers/networking/api_helper.dart';
import '../model/vendor_orders_model.dart';
import '../model/vendor_pagination_model.dart';

typedef HomeOrdersRequest = Future<ApiResponse> Function(String url, {Map<String, dynamic>? queryParameters});

/// Owns one home feed, including its page cursor and in-flight request.
class HomeOrdersFeed {
  HomeOrdersFeed({
    required this.url,
    required this.request,
    required this.onChanged,
    required this.sessionKey,
    this.onLoaded,
    this.onReset,
    this.onUnauthorized,
  });

  final String url;
  final HomeOrdersRequest request;
  final void Function() onChanged;
  final void Function(VendorModel)? onLoaded;
  final void Function()? onReset;
  final void Function()? onUnauthorized;
  final String? Function() sessionKey;
  String? _session;
  bool _hasSession = false;

  ApiResponse response = ApiResponse(state: ResponseState.sleep, data: null);
  List<VendorOrdersModel> orders = [];
  VendorModel? model;
  int nextPage = 1;
  bool hasPagination = true;
  bool isPaginating = false;

  int _generation = 0;
  int? _loadingPage;
  Future<void>? _inFlight;

  void reset() {
    _generation++;
    _loadingPage = null;
    _inFlight = null;
    response = ApiResponse(state: ResponseState.sleep, data: null);
    orders = [];
    model = null;
    nextPage = 1;
    hasPagination = true;
    isPaginating = false;
    onReset?.call();
  }

  bool ensureSession() {
    final session = sessionKey();
    if (_hasSession && session == _session) return false;
    reset();
    _session = session;
    _hasSession = true;
    return true;
  }

  Future<void> load({int? pageNumber, bool notify = true, bool forceRefresh = false}) {
    final sessionChanged = ensureSession();
    final session = _session;
    final page = sessionChanged || forceRefresh ? 1 : pageNumber ?? nextPage;
    if (!forceRefresh && _inFlight != null && (_loadingPage == page || page != 1)) {
      return _inFlight!;
    }
    if (page != 1 && !hasPagination) return Future.value();

    final generation = page == 1 ? ++_generation : _generation;
    final completer = Completer<void>();
    final future = completer.future;
    _inFlight = future;
    _loadingPage = page;
    if (page == 1) {
      // Keep an already loaded list visible while refreshing it.
      if (response.state != ResponseState.complete) {
        response = ApiResponse(state: ResponseState.loading, data: null);
      }
      isPaginating = false;
    } else {
      isPaginating = true;
    }
    if (notify) onChanged();

    void release() {
      if (identical(_inFlight, future)) {
        _inFlight = null;
        _loadingPage = null;
      }
    }

    _loadPage(page, generation, session, notify: notify).then(
      (_) {
        release();
        completer.complete();
      },
      onError: (Object error, StackTrace stackTrace) {
        release();
        completer.completeError(error, stackTrace);
      },
    );
    return future;
  }

  bool _accepts(int generation, String? session, {required bool notify}) {
    if (generation != _generation) return false;
    if (session == sessionKey()) return true;
    reset();
    if (notify) onChanged();
    return false;
  }

  Future<void> _loadPage(int page, int generation, String? session, {required bool notify}) async {
    try {
      final result = await request(url, queryParameters: {'page': page});
      if (!_accepts(generation, session, notify: notify)) return;
      if (result.state == ResponseState.complete) {
        final loaded = VendorModel.fromJson(result.data['data']);
        final rows = loaded.data ?? <VendorOrdersModel>[];
        orders = page == 1 ? rows : [...orders, ...rows];
        model = loaded;
        hasPagination = page < (loaded.meta?.lastPage ?? page);
        nextPage = hasPagination ? page + 1 : page;
        onLoaded?.call(loaded);
      }
      response = result;
      if (result.state == ResponseState.unauthorized) onUnauthorized?.call();
    } catch (_) {
      if (_accepts(generation, session, notify: notify)) {
        response = ApiResponse(state: ResponseState.error, data: {'message': 'تعذر تحميل الطلبات، حاول مرة أخرى'});
      }
    } finally {
      if (generation == _generation) {
        isPaginating = false;
        if (notify) onChanged();
      }
    }
  }
}
