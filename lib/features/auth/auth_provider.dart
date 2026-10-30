import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider();

  bool isSubmitting = false;
  bool obscurePassword = true;

  final usernameController = TextEditingController(
    text: ApiConstants.testUsername,
  );
  final passwordController = TextEditingController(
    text: ApiConstants.testPassword,
  );

  String? usernameError;
  String? passwordError;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void refresh() {
    if (_isDisposed) return;
    notifyListeners();
  }

  void onUsernameChanged(String value) {
    if (usernameError == null) return;
    usernameError = null;
    refresh();
  }

  void onPasswordChanged(String value) {
    if (passwordError == null) return;
    passwordError = null;
    refresh();
  }

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    refresh();
  }

  Future<void> onLoginTap(BuildContext context) async {
    if (!_validate()) return;

    final loggedIn = await _runSubmitting(() async {
      final result = await AuthRepository.login(
        username: usernameController.text.trim(),
        password: passwordController.text,
      );

      await AuthSession.markLoggedIn(
        token: result.accessToken,
        refreshToken: result.refreshToken,
        userId: result.user.id.toString(),
        userDataJson: jsonEncode(result.user.toJson()),
      );

      ApiService.resetClient();
      return true;
    });

    if (!loggedIn || _isDisposed) return;

    final navigator = navigatorKey.currentState;
    if (navigator == null) return;
    navigator.pushNamedAndRemoveUntil(
      ProductsScreen.routeName,
      (route) => false,
    );
  }

  Future<bool> _runSubmitting(Future<bool> Function() action) async {
    if (isSubmitting) return false;
    isSubmitting = true;
    refresh();
    try {
      return await action();
    } catch (e) {
      ErrorHandler.handle(e);
      return false;
    } finally {
      isSubmitting = false;
      refresh();
    }
  }

  bool _validate() {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    usernameError = username.isEmpty ? 'Username is required' : null;
    passwordError = password.isEmpty ? 'Password is required' : null;

    refresh();
    return usernameError == null && passwordError == null;
  }
}
