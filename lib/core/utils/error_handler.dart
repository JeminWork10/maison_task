import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class ErrorHandler {
  ErrorHandler._();

  static String handle(dynamic e, {bool showToast = true}) {
    String message = 'Something went wrong';

    if (e is AppException) {
      message = e.message;
    } else if (e is DioException) {
      message = _handleDioError(e);
    } else if (e is PlatformException) {
      message = (e.message?.trim().isNotEmpty ?? false)
          ? e.message!.trim()
          : e.code;
    } else if (e is FormatException) {
      message = e.message;
    } else if (e != null) {
      message = e.toString().replaceFirst('Exception: ', '');
    }

    if (showToast) {
      showErrorToast(message);
    }

    return message;
  }

  static String _handleDioError(DioException e) {
    if (e.error is AppException) {
      return (e.error as AppException).message;
    }

    switch (e.type) {
      case DioExceptionType.connectionError:
        return 'Connection error';
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout';
      case DioExceptionType.badResponse:
        return _extractServerMessage(e);
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error occurred';
    }
  }

  static String _extractServerMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map) {
        final response = AppResponse.fromJson(
          Map<String, dynamic>.from(data),
          e.response?.statusCode,
        );
        return extractApiErrorMessage(response: response);
      }
    } catch (_) {}

    return 'Server error occurred';
  }
}
