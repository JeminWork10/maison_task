import 'package:minimalist_store/store_app.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  static const routeName = '/product-details';

  static Map<String, dynamic>? routeArgsOf(Object? arguments) {
    if (arguments == null) return null;
    if (arguments is Map<String, dynamic>) {
      return Map<String, dynamic>.from(arguments);
    }
    if (arguments is Map) {
      return arguments.map((key, value) => MapEntry(key.toString(), value));
    }
    if (arguments is ProductModel) {
      return arguments.toRouteArgs();
    }
    if (arguments is String) {
      final trimmed = arguments.trim();
      if (int.tryParse(trimmed) != null) {
        return <String, dynamic>{'id': trimmed};
      }
    }
    return null;
  }

  static Widget builder(BuildContext context) {
    final args = routeArgsOf(ModalRoute.of(context)?.settings.arguments);
    return ChangeNotifierProvider<ProductDetailsProvider>(
      create: (c) => ProductDetailsProvider(args: args),
      child: const ProductDetailsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<ProductDetailsProvider>();
    final isLoading = context.watch<ProductDetailsProvider>().isLoading;
    final errorMessage = context.watch<ProductDetailsProvider>().errorMessage;
    final product = context.watch<ProductDetailsProvider>().product;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AppPageBackground(
        child: AppSwitcher(
          switchKey: isLoading
              ? 'loading'
              : errorMessage != null
              ? 'error'
              : 'data',
          child: isLoading
              ? const Center(child: AppLoader())
              : errorMessage != null || product == null
              ? Column(
                  children: [
                    SafeArea(
                      bottom: false,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.w),
                          child: CommonIconButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            height: 36.w,
                            width: 36.w,
                            iconSize: 16.h,
                            borderRadius: 8.r,
                            buttonColor: AppColors.surface,
                            onTap: () => context.navigator.pop(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ErrorView(
                        message: errorMessage ?? 'Product not found',
                        onRetry: state.loadDetail,
                      ),
                    ),
                  ],
                )
              : _ProductDetailsBody(product: product),
        ),
      ),
    );
  }
}

class _ProductDetailsBody extends StatefulWidget {
  const _ProductDetailsBody({required this.product});

  final ProductModel product;

  @override
  State<_ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<_ProductDetailsBody> {
  int _page = 0;

  ProductModel get product => widget.product;

  @override
  Widget build(BuildContext context) {
    final gallery = product.images.isNotEmpty
        ? product.images
        : [product.primaryImage];

    // Keep gallery + chrome below the status bar / notch.
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Hero(
                  tag: 'product-image-${product.id}',
                  child: SizedBox(
                    height: 360.h,
                    width: double.maxFinite,
                    child: PageView.builder(
                      itemCount: gallery.length,
                      onPageChanged: (value) => setState(() => _page = value),
                      itemBuilder: (context, index) {
                        return ColoredBox(
                          color: AppColors.surfaceMuted,
                          child: CachedImage(
                            gallery[index],
                            height: 360.h,
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
                  child: Row(
                    children: [
                      CommonIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        height: 36.w,
                        width: 36.w,
                        iconSize: 16.h,
                        borderRadius: 8.r,
                        buttonColor: AppColors.surface.withValues(alpha: 0.92),
                        onTap: () => context.navigator.pop(),
                      ),
                      const Spacer(),
                      if (gallery.length > 1)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '${_page + 1} / ${gallery.length}',
                            style: styleW600S12.copyWith(
                              color: AppColors.primaryDeep,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.horizontalPadding,
              22.h,
              AppConstants.horizontalPadding,
              AppConstants.safeAreaPadding.bottom + 28.h,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  product.category.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styleEyebrow.copyWith(color: AppColors.primary),
                ),
                10.h.spaceVertical,
                Text(
                  product.title,
                  style: styleDisplayS28.copyWith(color: AppColors.primaryDeep),
                ),
                14.h.spaceVertical,
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.w,
                  runSpacing: 6.h,
                  children: [
                    Text(
                      '\$${product.price.formattedAmount}',
                      style: styleW700S22.copyWith(color: AppColors.primary),
                    ),
                    if (product.discountPercentage > 0) ...[
                      Text(
                        '\$${product.originalPrice.toStringAsFixed(2)}',
                        style: styleW400S14.copyWith(
                          color: AppColors.grey2,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        color: AppColors.primary,
                        child: Text(
                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                          style: styleW600S12.copyWith(color: AppColors.white),
                        ),
                      ),
                    ],
                  ],
                ),
                12.h.spaceVertical,
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.champagne,
                      size: 18.h,
                    ),
                    4.w.spaceHorizontal,
                    Expanded(
                      child: Text(
                        '${product.rating.toStringAsFixed(1)} · ${product.reviews.length} reviews',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleW500S14.copyWith(color: AppColors.text06),
                      ),
                    ),
                    8.w.spaceHorizontal,
                    Flexible(
                      child: Text(
                        product.isInStock
                            ? 'In stock · ${product.stock}'
                            : 'Out of stock',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: styleW600S14.copyWith(
                          color: product.isInStock
                              ? AppColors.green
                              : AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                28.h.spaceVertical,
                Text(
                  'About',
                  style: styleW700S16.copyWith(color: AppColors.primaryDeep),
                ),
                8.h.spaceVertical,
                Text(
                  product.description,
                  style: styleW400S14.copyWith(
                    height: 1.55,
                    color: AppColors.text08,
                  ),
                ),
                28.h.spaceVertical,
                Text(
                  'Details',
                  style: styleW700S16.copyWith(color: AppColors.primaryDeep),
                ),
                12.h.spaceVertical,
                _MetaRow(label: 'Brand', value: product.displayBrand),
                _MetaRow(label: 'SKU', value: product.sku ?? '—'),
                _MetaRow(
                  label: 'Availability',
                  value: product.availabilityStatus ?? '—',
                ),
                _MetaRow(
                  label: 'Warranty',
                  value: product.warrantyInformation ?? '—',
                ),
                _MetaRow(
                  label: 'Shipping',
                  value: product.shippingInformation ?? '—',
                ),
                if (product.reviews.isNotEmpty) ...[
                  28.h.spaceVertical,
                  Text(
                    'Reviews',
                    style: styleW700S16.copyWith(color: AppColors.primaryDeep),
                  ),
                  14.h.spaceVertical,
                  ...product.reviews.map(
                    (review) => _ReviewTile(review: review),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.text01)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: styleW500S14.copyWith(color: AppColors.text06),
            ),
          ),
          Expanded(child: Text(value, style: styleW500S14)),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final ProductReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: AppColors.text01),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.reviewerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styleW600S14,
                ),
              ),
              Icon(Icons.star_rounded, size: 14.h, color: AppColors.champagne),
              4.w.spaceHorizontal,
              Text(
                review.rating.toStringAsFixed(1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: styleW500S14,
              ),
            ],
          ),
          8.h.spaceVertical,
          Text(
            review.comment,
            style: styleW400S14.copyWith(height: 1.45, color: AppColors.text08),
          ),
          if (review.date.isNotEmpty) ...[
            8.h.spaceVertical,
            Text(
              _formatDate(review.date),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: styleW400S12.copyWith(color: AppColors.grey2),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return parsed.toLocal().toDdMmmYyyy;
  }
}
