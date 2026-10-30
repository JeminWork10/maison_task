import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.dio);

  final Dio dio;
  bool _isLoggingOut = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageService.getData(SecureStorageKeys.token);
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode ?? 0;
    if (statusCode == 401) {
      _handleUnauthorized(response.requestOptions, response, handler);
      return;
    }
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && AuthSession.isLoggedIn) {
      if (!_isLoggingOut) {
        _isLoggingOut = true;
        await logoutUser();
      }
    }

    final exception = _mapDioError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        response: err.response,
        type: err.type,
      ),
    );
  }

  void _handleUnauthorized(
    RequestOptions requestOptions,
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    final isAuthCall = requestOptions.path.contains('/auth/');
    if (AuthSession.isLoggedIn && !_isLoggingOut && !isAuthCall) {
      _isLoggingOut = true;
      logoutUser();
    }

    handler.reject(
      DioException(
        requestOptions: requestOptions,
        response: response,
        error: _mapDioError(
          DioException(
            requestOptions: requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        ),
        type: DioExceptionType.badResponse,
      ),
    );
  }

  AppException _mapDioError(DioException err) {
    if (err.error is AppException) {
      return err.error as AppException;
    }

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return AppException(message: 'Connection timeout');
    }

    if (err.type == DioExceptionType.connectionError) {
      return AppException(message: 'Connection Error');
    }

    final response = err.response;
    final data = response?.data;
    if (data is Map) {
      final parsed = AppResponse.fromJson(
        Map<String, dynamic>.from(data),
        response?.statusCode,
      );
      return exceptionFromResponse(parsed);
    }

    final status = response?.statusCode;
    switch (status) {
      case 400:
        return AppException(
          message: 'Bad request',
          statusCode: 400,
          errorCode: ApiErrorCodes.validationError,
        );
      case 401:
        return AppException(
          message: 'Please sign in to continue',
          statusCode: 401,
          errorCode: ApiErrorCodes.unauthorized,
        );
      case 404:
        return AppException(
          message: 'Requested item was not found',
          statusCode: 404,
          errorCode: ApiErrorCodes.resourceNotFound,
        );
      case 429:
        return AppException(
          message: 'Too many requests. Please try again later',
          statusCode: 429,
          errorCode: ApiErrorCodes.tooManyRequests,
        );
      case 500:
        return AppException(message: 'Server error', statusCode: 500);
      default:
        return AppException(
          message: 'Something went wrong',
          statusCode: status,
        );
    }
  }
}
