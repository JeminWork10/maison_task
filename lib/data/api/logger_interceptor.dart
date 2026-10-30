import 'package:minimalist_store/store_app_extra.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━ REQUEST ━━━━━━━━━━');
      debugPrint('➡️ ${options.method} ${options.uri}');
      debugPrint('Headers: ${options.headers}');
      debugPrint('Query: ${options.queryParameters}');
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━ RESPONSE ━━━━━━━━━━');
      debugPrint('⬅️ ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━ ERROR ━━━━━━━━━━');
      debugPrint('❌ ${err.requestOptions.uri}');
      debugPrint('Type: ${err.type}');
      debugPrint('Message: ${err.message}');
      debugPrint('Status: ${err.response?.statusCode}');
    }
    handler.next(err);
  }
}
