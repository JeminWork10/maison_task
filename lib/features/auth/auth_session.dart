import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class AuthSession {
  AuthSession._();

  static final ValueNotifier<bool> listenable = ValueNotifier(false);

  static bool get isLoggedIn => listenable.value;

  static UserModel? savedUser() {
    final raw = PrefService.getString(PrefKeys.userData);
    if (raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return UserModel.fromJson(decoded);
      }
      if (decoded is Map) {
        return UserModel.fromJson(
          decoded.map((key, value) => MapEntry(key.toString(), value)),
        );
      }
    } catch (_) {}
    return null;
  }

  static void restore() {
    listenable.value = PrefService.getBool(PrefKeys.isLogin);
  }

  static Future<void> markLoggedIn({
    required String token,
    String? refreshToken,
    String? userId,
    String? userDataJson,
  }) async {
    await PrefService.set(PrefKeys.isLogin, true);

    if (userId != null && userId.isNotEmpty && userId != '0') {
      await PrefService.set(PrefKeys.userId, userId);
    }
    if (userDataJson != null && userDataJson.isNotEmpty) {
      await PrefService.set(PrefKeys.userData, userDataJson);
    }

    final accessToken = token.trim();
    if (accessToken.isNotEmpty) {
      await SecureStorageService.saveData(SecureStorageKeys.token, accessToken);
    }
    final refresh = refreshToken?.trim() ?? '';
    if (refresh.isNotEmpty) {
      await SecureStorageService.saveData(
        SecureStorageKeys.refreshToken,
        refresh,
      );
    }
    listenable.value = true;
  }

  static Future<void> rememberUser(UserModel user) async {
    await PrefService.set(PrefKeys.userData, jsonEncode(user.toJson()));
    if (user.id != 0) {
      await PrefService.set(PrefKeys.userId, user.id.toString());
    }
  }

  static Future<String> getToken() {
    return SecureStorageService.getData(SecureStorageKeys.token);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token.trim().isNotEmpty;
  }

  static Future<void> clear() async {
    await PrefService.set(PrefKeys.isLogin, false);
    await PrefService.removeKey(PrefKeys.userData);
    await PrefService.removeKey(PrefKeys.userId);
    await SecureStorageService.deleteData(SecureStorageKeys.token);
    await SecureStorageService.deleteData(SecureStorageKeys.refreshToken);
    listenable.value = false;
  }
}
