import 'package:minimalist_store/store_app.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic details;

  AppException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  bool get isUnauthorized =>
      errorCode == ApiErrorCodes.unauthorized || statusCode == 401;

  @override
  String toString() => message;
}

String extractApiErrorMessage({
  required AppResponse response,
  String? fallbackMessage,
}) {
  final bodyMessage = response.message?.trim() ?? '';
  if (bodyMessage.isNotEmpty) return bodyMessage;

  if (response.details is Map) {
    final details = response.details as Map;
    for (final key in ['message', 'error', 'description']) {
      final value = details[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
  }

  return fallbackMessage ?? 'Something went wrong. Please try again.';
}

AppException exceptionFromResponse(
  AppResponse response, {
  String? fallbackMessage,
}) {
  return AppException(
    message: extractApiErrorMessage(
      response: response,
      fallbackMessage: fallbackMessage,
    ),
    statusCode: response.statusCode,
    errorCode: response.errorCode,
    details: response.details,
  );
}
