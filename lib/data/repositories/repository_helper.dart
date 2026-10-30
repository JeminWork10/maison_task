import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

Future<AppResponse> repoRequest({
  required RequestType type,
  required String path,
  Map<String, dynamic>? query,
  dynamic body,
  CancelToken? cancelToken,
  Options? options,
}) async {
  final response = await ApiService.request(
    type: type,
    path: path,
    query: query,
    body: body,
    cancelToken: cancelToken,
    options: options,
  );

  if (!response.isSuccess) {
    throw exceptionFromResponse(response);
  }

  return response;
}
