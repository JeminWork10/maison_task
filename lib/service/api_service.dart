import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

enum RequestType { get, post, put, patch, delete }

class ApiService {
  ApiService._();

  static Dio? _dio;

  static Dio get dio {
    if (_dio != null) return _dio!;

    _dio = Dio(
      BaseOptions(
        connectTimeout: 30.seconds,
        receiveTimeout: 30.seconds,
        sendTimeout: 30.seconds,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status != null,
      ),
    );

    _dio!.interceptors.add(AuthInterceptor(_dio!));
    _dio!.interceptors.add(RetryInterceptor(_dio!));
    _dio!.interceptors.add(LoggerInterceptor());

    return _dio!;
  }

  static void resetClient() {
    _dio?.close(force: true);
    _dio = null;
  }

  static Future<AppResponse> request<T>({
    required String path,
    required RequestType type,
    Map<String, dynamic>? query,
    dynamic body,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    final cleanedQuery = cleanQuery(query);

    try {
      switch (type) {
        case RequestType.get:
          return _parseAppResponse(
            await dio.get<T>(
              path,
              data: body,
              queryParameters: cleanedQuery,
              cancelToken: cancelToken,
              options: options,
            ),
          );
        case RequestType.post:
          return _parseAppResponse(
            await dio.post<T>(
              path,
              data: body,
              queryParameters: cleanedQuery,
              cancelToken: cancelToken,
              options: options,
            ),
          );
        case RequestType.put:
          return _parseAppResponse(
            await dio.put<T>(
              path,
              data: body,
              queryParameters: cleanedQuery,
              cancelToken: cancelToken,
              options: options,
            ),
          );
        case RequestType.patch:
          return _parseAppResponse(
            await dio.patch<T>(
              path,
              data: body,
              queryParameters: cleanedQuery,
              cancelToken: cancelToken,
              options: options,
            ),
          );
        case RequestType.delete:
          return _parseAppResponse(
            await dio.delete<T>(
              path,
              data: body,
              queryParameters: cleanedQuery,
              cancelToken: cancelToken,
              options: options,
            ),
          );
      }
    } on DioException {
      rethrow;
    }
  }

  static Map<String, dynamic>? cleanQuery(Map<String, dynamic>? query) {
    if (query == null || query.isEmpty) return null;

    final cleaned = <String, dynamic>{};
    query.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      cleaned[key] = value;
    });

    return cleaned.isEmpty ? null : cleaned;
  }

  static AppResponse _parseAppResponse(Response response) {
    final data = response.data;

    if (data == null) {
      return AppResponse(statusCode: response.statusCode);
    }

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) {
        return AppResponse(statusCode: response.statusCode);
      }
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) {
        return AppResponse.fromJson(
          Map<String, dynamic>.from(decoded),
          response.statusCode,
        );
      }
    }

    if (data is Map) {
      return AppResponse.fromJson(
        Map<String, dynamic>.from(data),
        response.statusCode,
      );
    }

    if (data is List) {
      return AppResponse(data: data, statusCode: response.statusCode);
    }

    throw FormatException('Unexpected response format: ${data.runtimeType}');
  }
}
