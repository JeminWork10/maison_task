import 'package:minimalist_store/store_app.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static const routeName = '/products';

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider<ProductsProvider>(
      create: (c) => ProductsProvider(),
      child: const ProductsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<ProductsProvider>();
    final products = context.watch<ProductsProvider>().products;
    final isLoading = context.watch<ProductsProvider>().isLoading;
    final isLoadingMore = context.watch<ProductsProvider>().isLoadingMore;
    final hasMore = context.watch<ProductsProvider>().hasMore;
    final errorMessage = context.watch<ProductsProvider>().errorMessage;
    final user = AuthSession.savedUser();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppPageBackground(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppConstants.horizontalPadding,
                  8.h,
                  AppConstants.horizontalPadding,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName.toUpperCase(),
                      style: styleEyebrow.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 3.5,
                      ),
                    ),
                    6.h.spaceVertical,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Collection',
                            style: styleDisplayS34.copyWith(
                              color: AppColors.primaryDeep,
                            ),
                          ),
                        ),
                        if (user != null) ...[
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 80.w),
                            child: Text(
                              user.firstName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: styleW500S14.copyWith(
                                color: AppColors.text06,
                              ),
                            ),
                          ),
                          8.w.spaceHorizontal,
                        ],
                        CommonIconButton(
                          icon: Icons.logout_rounded,
                          height: 36.w,
                          width: 36.w,
                          iconSize: 18.h,
                          borderRadius: 8.r,
                          buttonColor: AppColors.surface,
                          iconColor: AppColors.primary,
                          onTap: state.onLogoutTap,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  state.onProductsScroll(notification);
                  return false;
                },
                child: CustomSingleChildScroll(
                  onRefresh: () =>
                      state.fetchProducts(reset: true, refreshing: true),
                  isLoading: isLoading,
                  showEmpty:
                      !isLoading && (products.isEmpty || errorMessage != null),
                  emptyWidget: errorMessage != null
                      ? ErrorView(
                          message: errorMessage,
                          onRetry: () => state.fetchProducts(reset: true),
                        )
                      : EmptyView(
                          title: 'No products found',
                          message: 'Pull to refresh or try again later.',
                          buttonText: 'Retry',
                          onButtonPressed: () =>
                              state.fetchProducts(reset: true),
                        ),
                  padding: EdgeInsets.fromLTRB(
                    AppConstants.horizontalPadding,
                    8.h,
                    AppConstants.horizontalPadding,
                    AppConstants.safeAreaPadding.bottom + 24.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${products.length}${hasMore ? '+' : ''} pieces',
                        style: styleW400S12.copyWith(color: AppColors.text06),
                      ),
                      10.h.spaceVertical,
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14.w,
                          mainAxisSpacing: 22.h,
                          childAspectRatio: 0.62,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return CommonProductCard(
                            product: product,
                            index: index,
                            onTap: () => state.onProductTap(context, product),
                          );
                        },
                      ),
                      if (isLoadingMore) const HasMoreWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
