import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class NetworkProvider extends ChangeNotifier {
  NetworkProvider() {
    init();
  }

  final Connectivity _connectivity = Connectivity();

  bool isOnline = true;
  bool _isDialogOpen = false;
  Function() _retryCallback = () async {};
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Completer<void>? _initialCheck;
  bool _hasInitialStatus = false;

  void init() async {
    _initialCheck = Completer<void>();
    try {
      final result = await _connectivity.checkConnectivity();
      _applyStatus(result, fromInitial: true);
    } finally {
      _hasInitialStatus = true;
      if (!(_initialCheck?.isCompleted ?? true)) {
        _initialCheck!.complete();
      }
    }

    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> waitForInitialStatus() async {
    if (_hasInitialStatus) return;
    final pending = _initialCheck;
    if (pending != null) await pending.future;
  }

  Future<bool> refreshStatus() async {
    final result = await _connectivity.checkConnectivity();
    final online = checkInternet(result);
    if (online != isOnline) {
      isOnline = online;
      notifyListeners();
      if (!isOnline) {
        _showNoInternetDialog();
      } else {
        _closeDialogIfOpen();
      }
    }
    return isOnline;
  }

  void _updateStatus(List<ConnectivityResult> result) {
    _applyStatus(result, fromInitial: false);
  }

  void _applyStatus(
    List<ConnectivityResult> result, {
    required bool fromInitial,
  }) {
    if (result.isEmpty) return;

    final online = checkInternet(result);
    if (online == isOnline && _hasInitialStatus) return;

    final wasOnline = isOnline;
    isOnline = online;
    notifyListeners();

    if (!isOnline) {
      _showNoInternetDialog();
      return;
    }

    _closeDialogIfOpen();
    if (!fromInitial && !wasOnline) {
      Future.microtask(() => _retryCallback.call());
    }
  }

  bool checkInternet(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet);
  }

  void setRetryCallback(Function() retry) {
    _retryCallback = retry;
  }

  void clearRetryCallback() {
    _retryCallback = () {};
  }

  void _showNoInternetDialog() {
    if (_isDialogOpen) return;

    final overlayContext = navigatorKey.currentState?.overlay?.context;
    if (overlayContext == null || !overlayContext.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isOnline) _showNoInternetDialog();
      });
      return;
    }

    _isDialogOpen = true;

    showDialog<void>(
      context: overlayContext,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding,
            ),
            child: Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 72.h,
                      color: AppColors.primary,
                    ),
                    12.h.spaceVertical,
                    Text(
                      'No Internet Connection',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: styleW700S18.copyWith(color: AppColors.primary),
                    ),
                    10.h.spaceVertical,
                    Text(
                      'Check your connection and try again.',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: styleW500S14.copyWith(color: AppColors.text06),
                    ),
                    20.h.spaceVertical,
                    CommonButton(title: 'Try Again', onTap: _onTryAgainTap),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _isDialogOpen = false;
    });
  }

  Future<void> _onTryAgainTap() async {
    final result = await _connectivity.checkConnectivity();
    final online = checkInternet(result);
    if (!online) return;

    isOnline = true;
    notifyListeners();
    _closeDialogIfOpen();
    await Future.microtask(() => _retryCallback.call());
  }

  void _closeDialogIfOpen() {
    if (!_isDialogOpen) return;

    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      _isDialogOpen = false;
      return;
    }

    // Dialog routes sit above page routes; never pop the last page.
    if (navigator.canPop()) {
      navigator.pop();
    }
    _isDialogOpen = false;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
