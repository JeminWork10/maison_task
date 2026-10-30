import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class ProductsProvider extends ChangeNotifier {
  ProductsProvider() {
    fetchProducts(reset: true);
  }

  static const int pageLimit = ApiConstants.defaultLimit;

  bool _isDisposed = false;
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = false;
  int _page = ApiConstants.defaultPage;

  CancelToken? _productsCancelToken;

  List<ProductModel> products = [];
  String? errorMessage;

  @override
  void dispose() {
    _isDisposed = true;
    _productsCancelToken?.cancel();
    super.dispose();
  }

  void refresh() {
    if (_isDisposed) return;
    notifyListeners();
  }

  void onProductsScroll(ScrollNotification notification) {
    if (notification.depth != 0) return;
    if (notification.metrics.axis != Axis.vertical) return;
    if (notification.metrics.viewportDimension <= 0) return;
    if (notification is! ScrollUpdateNotification &&
        notification is! ScrollMetricsNotification) {
      return;
    }

    final metrics = notification.metrics;
    final extentAfter = metrics.maxScrollExtent - metrics.pixels;
    final nearEnd = metrics.maxScrollExtent <= 80 || extentAfter <= 200;
    if (!nearEnd) return;
    loadMore();
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore || isLoading || _isDisposed) return;
    await fetchProducts(reset: false);
  }

  Future<void> fetchProducts({
    required bool reset,
    bool refreshing = false,
  }) async {
    if (_isDisposed) return;
    if (!reset && (isLoading || isLoadingMore)) return;

    if (reset) {
      _page = ApiConstants.defaultPage;
      isLoadingMore = false;
      errorMessage = null;
      if (!refreshing) isLoading = true;
    } else {
      isLoadingMore = true;
    }
    refresh();

    final token = CancelToken();
    _productsCancelToken?.cancel();
    _productsCancelToken = token;

    try {
      final result = await CatalogRepository.fetchProducts(
        page: _page,
        limit: pageLimit,
        cancelToken: _productsCancelToken,
      );

      final existingIds = products.map((item) => item.id).toSet();
      final fresh = reset
          ? result.items
          : result.items.where((item) => !existingIds.contains(item.id)).toList();

      if (reset) {
        products = fresh;
      } else if (fresh.isNotEmpty) {
        products = [...products, ...fresh];
      }
      hasMore = fresh.isEmpty && !reset ? false : _hasAnotherPage(result);
      if (hasMore) _page += 1;
      errorMessage = null;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;
      errorMessage = ErrorHandler.handle(e, showToast: false);
      if (reset) {
        products = [];
        hasMore = false;
      }
    } catch (e) {
      errorMessage = ErrorHandler.handle(e, showToast: false);
      if (reset) {
        products = [];
        hasMore = false;
      }
    } finally {
      if (identical(_productsCancelToken, token)) {
        isLoadingMore = false;
        isLoading = false;
        refresh();
      }
    }
  }

  bool _hasAnotherPage(PaginatedResponse<ProductModel> result) {
    if (result.pagination.hasNextPage != null) return result.hasMore;
    if (result.hasMore) return true;
    final pageSize = result.limit > 0 ? result.limit : pageLimit;
    if (result.items.length < pageSize) return false;
    if (result.total <= 0) return true;
    return result.total > products.length;
  }

  Future<void> onLogoutTap() async {
    await logoutUser();
  }

  void onProductTap(BuildContext context, ProductModel product) {
    context.navigator.pushNamed(
      ProductDetailsScreen.routeName,
      arguments: product.toRouteArgs(),
    );
  }
}
