import 'package:minimalist_store/store_app.dart';

class ApiConstants {
  static bool isDebugMode = kDebugMode;

  static const String host = 'https://dummyjson.com';

  static String get baseUrl => host;

  static String get assetBaseUrl => '$host/';

  static String resolveUploadUrl(String? url) {
    final raw = url?.trim() ?? '';
    if (raw.isEmpty) return raw;
    if (raw.startsWith('http')) return raw;
    return '$assetBaseUrl${raw.replaceFirst(RegExp(r'^/'), '')}';
  }

  static const int defaultPage = 1;
  static const int defaultLimit = 20;
  static const int maxLimit = 100;

  static const String testUsername = 'emilys';
  static const String testPassword = 'emilyspass';

  static String get authLogin => '$baseUrl/auth/login';

  static String get authMe => '$baseUrl/auth/me';

  static String get products => '$baseUrl/products';

  static String productById(int id) => '$baseUrl/products/$id';

  static Map<String, dynamic> pageQuery({
    int page = defaultPage,
    int limit = defaultLimit,
  }) {
    final safeLimit = limit.clamp(1, maxLimit);
    final safePage = page < 1 ? defaultPage : page;
    return {'limit': safeLimit, 'skip': (safePage - 1) * safeLimit};
  }
}
