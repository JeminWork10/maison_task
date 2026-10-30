import 'package:minimalist_store/data/repositories/repository_helper.dart';
import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class CatalogRepository {
  CatalogRepository._();

  static Future<PaginatedResponse<ProductModel>> fetchProducts({
    int page = ApiConstants.defaultPage,
    int limit = ApiConstants.defaultLimit,
    CancelToken? cancelToken,
  }) async {
    final response = await repoRequest(
      type: RequestType.get,
      path: ApiConstants.products,
      query: ApiConstants.pageQuery(page: page, limit: limit),
      cancelToken: cancelToken,
    );

    final data = response.dataAsMap ?? {};
    return PaginatedResponse.fromDummyJson(data, ProductModel.fromJson);
  }

  static Future<ProductModel> fetchProductById({
    required int id,
    CancelToken? cancelToken,
  }) async {
    final response = await repoRequest(
      type: RequestType.get,
      path: ApiConstants.productById(id),
      cancelToken: cancelToken,
    );

    final data = response.dataAsMap;
    if (data == null) {
      throw AppException(message: 'Invalid product response');
    }
    return ProductModel.fromJson(data);
  }
}
