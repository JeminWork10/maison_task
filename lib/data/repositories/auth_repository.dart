import 'package:minimalist_store/data/repositories/repository_helper.dart';
import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class AuthRepository {
  AuthRepository._();

  static Future<AuthResponse> login({
    required String username,
    required String password,
    CancelToken? cancelToken,
  }) async {
    final response = await repoRequest(
      type: RequestType.post,
      path: ApiConstants.authLogin,
      body: {
        'username': username,
        'password': password,
        'expiresInMins': 60,
      },
      cancelToken: cancelToken,
    );

    final data = response.dataAsMap ?? {};
    final result = AuthResponse.fromJson(data);
    if (result.accessToken.trim().isEmpty) {
      throw AppException(message: 'Access token missing from login response');
    }
    return result;
  }

  static Future<UserModel> fetchMe({CancelToken? cancelToken}) async {
    final response = await repoRequest(
      type: RequestType.get,
      path: ApiConstants.authMe,
      cancelToken: cancelToken,
    );
    final data = response.dataAsMap;
    if (data == null) {
      throw AppException(message: 'Invalid session response');
    }
    final user = UserModel.fromJson(data);
    await AuthSession.rememberUser(user);
    return user;
  }
}
