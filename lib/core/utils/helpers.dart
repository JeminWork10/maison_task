import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

void showErrorToast(String msg) {
  showCustomToast(msg, error: true);
}

void showSuccessToast(String msg) {
  showCustomToast(msg);
}

bool isConnectivityError(Object? error) {
  if (error is SocketException) return true;

  if (error is DioException) {
    if (error.error is SocketException) return true;
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      default:
        break;
    }
    if (error.error is AppException) {
      return isConnectivityError(error.error);
    }
  }

  if (error is AppException) {
    final message = error.message.toLowerCase();
    return message.contains('connection') ||
        message.contains('timeout') ||
        message.contains('network') ||
        message.contains('socket') ||
        message.contains('internet');
  }

  final text = error?.toString().toLowerCase() ?? '';
  return text.contains('socketexception') ||
      text.contains('connection error') ||
      text.contains('connection timeout') ||
      text.contains('network');
}

Future<void> logoutUser({bool navigate = true}) async {
  closeLoaderDialog();
  await AuthSession.clear();
  ApiService.resetClient();
  if (!navigate) return;

  final navigator = navigatorKey.currentState;
  if (navigator == null) return;
  navigator.pushNamedAndRemoveUntil(
    LoginScreen.routeName,
    (route) => false,
  );
}
