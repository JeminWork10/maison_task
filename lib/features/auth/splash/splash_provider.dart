import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class SplashProvider extends ChangeNotifier {
  bool _splashInit = false;
  bool _isDisposed = false;
  bool _enteredApp = false;
  bool _retryArmed = false;

  @override
  void dispose() {
    _isDisposed = true;
    _clearNetworkRetry();
    super.dispose();
  }

  void refresh() {
    if (_isDisposed) return;
    notifyListeners();
  }

  Future<void> redirectToNext(BuildContext context) async {
    if (_isDisposed || _enteredApp || _splashInit) return;

    _armNetworkRetry(context);

    final network = context.read<NetworkProvider>();
    await network.waitForInitialStatus();
    if (_isDisposed || !context.mounted) return;

    final online = await network.refreshStatus();
    if (_isDisposed || !context.mounted) return;

    if (!online) return;

    try {
      _splashInit = true;
      refresh();

      await _prepareSession();
      if (_isDisposed || !context.mounted) return;

      _clearNetworkRetry();
      _enterApp(context);
    } catch (e) {
      debugPrint('Splash bootstrap failed: $e');
      _splashInit = false;
      refresh();

      if (_isDisposed || !context.mounted) return;

      final network = context.read<NetworkProvider>();
      if (isConnectivityError(e) || !network.isOnline) {
        if (network.isOnline) {
          unawaited(redirectToNext(context));
        }
        return;
      }

      ErrorHandler.handle(e);
      Future<void>.delayed(const Duration(seconds: 2), () {
        if (_isDisposed || _enteredApp || _splashInit) return;
        if (!context.mounted) return;
        unawaited(redirectToNext(context));
      });
    }
  }

  Future<void> _prepareSession() async {
    if (!AuthSession.isLoggedIn) return;

    final hasToken = await AuthSession.hasToken();
    if (!hasToken) {
      await AuthSession.clear();
      return;
    }

    try {
      await AuthRepository.fetchMe();
    } catch (e) {
      if (e is AppException && e.isUnauthorized) {
        await AuthSession.clear();
        return;
      }
      rethrow;
    }
  }

  void _armNetworkRetry(BuildContext context) {
    if (_retryArmed || _isDisposed) return;
    _retryArmed = true;

    context.read<NetworkProvider>().setRetryCallback(() async {
      if (_isDisposed || _enteredApp || _splashInit) return;
      if (!context.mounted) return;
      await redirectToNext(context);
    });
  }

  void _clearNetworkRetry() {
    if (!_retryArmed) return;
    _retryArmed = false;

    final ctx = navigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) return;
    try {
      ctx.read<NetworkProvider>().clearRetryCallback();
    } catch (_) {}
  }

  void _enterApp(BuildContext context) {
    if (_enteredApp) return;

    // Prefer the root navigator key so splash never races a disposed local
    // NavigatorState during the first frame after bootstrap.
    final navigator = navigatorKey.currentState ??
        (context.mounted ? Navigator.maybeOf(context) : null);
    if (navigator == null) return;
    _enteredApp = true;
    _splashInit = true;

    navigator.pushNamedAndRemoveUntil(
      AuthSession.isLoggedIn
          ? ProductsScreen.routeName
          : LoginScreen.routeName,
      (route) => false,
    );
  }
}
