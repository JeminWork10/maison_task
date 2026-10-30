import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

class ProductDetailsProvider extends ChangeNotifier {
  ProductDetailsProvider({Map<String, dynamic>? args}) {
    _seedFromArgs(args);
    if (id != null) {
      isLoading = true;
      loadDetail();
    } else {
      errorMessage = 'Product not found';
    }
  }

  bool _isDisposed = false;
  bool isLoading = false;
  String? errorMessage;
  CancelToken? _cancelToken;

  int? id;
  ProductModel? product;

  @override
  void dispose() {
    _isDisposed = true;
    _cancelToken?.cancel();
    super.dispose();
  }

  void refresh() {
    if (_isDisposed) return;
    notifyListeners();
  }

  void _seedFromArgs(Map<String, dynamic>? args) {
    if (args == null) return;
    id = int.tryParse(args['id']?.toString() ?? '');
  }

  Future<void> loadDetail() async {
    final productId = id;
    if (productId == null) return;

    isLoading = true;
    errorMessage = null;
    refresh();

    final token = CancelToken();
    _cancelToken?.cancel();
    _cancelToken = token;

    try {
      product = await CatalogRepository.fetchProductById(
        id: productId,
        cancelToken: token,
      );
      errorMessage = null;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) return;
      errorMessage = ErrorHandler.handle(e, showToast: false);
    } catch (e) {
      errorMessage = ErrorHandler.handle(e, showToast: false);
    } finally {
      if (identical(_cancelToken, token)) {
        isLoading = false;
        refresh();
      }
    }
  }
}
