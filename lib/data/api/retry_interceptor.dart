import 'package:minimalist_store/store_app_extra.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor(this.dio, {this.maxRetries = 1});

  final Dio dio;
  final int maxRetries;

  static const _retryCountKey = 'retry_count';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry =
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout;

    final retryCount = err.requestOptions.extra[_retryCountKey] as int? ?? 0;

    if (!shouldRetry || retryCount >= maxRetries) {
      handler.reject(err);
      return;
    }

    final nextOptions = err.requestOptions
      ..extra[_retryCountKey] = retryCount + 1;

    await Future.delayed(Duration(seconds: 2 * (retryCount + 1)));

    try {
      handler.resolve(await dio.fetch(nextOptions));
    } on DioException catch (e) {
      handler.reject(e);
    }
  }
}
