import 'package:minimalist_store/store_app.dart';

class CommonProductCard extends StatelessWidget {
  const CommonProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.index = 0,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + (index % 6) * 40),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: AppSplashEffect(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-image-${product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: ColoredBox(
                    color: AppColors.surfaceMuted,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedImage(
                          product.thumbnail,
                          fit: BoxFit.cover,
                        ),
                        if (product.discountPercentage > 0)
                          Positioned(
                            left: 8.w,
                            top: 8.h,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              color: AppColors.primary,
                              child: Text(
                                '-${product.discountPercentage.toStringAsFixed(0)}%',
                                style: styleW600S12.copyWith(
                                  color: AppColors.white,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(2.w, 10.h, 2.w, 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styleEyebrow.copyWith(
                      color: AppColors.primary,
                      fontSize: 10.sp,
                    ),
                  ),
                  4.h.spaceVertical,
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: styleW600S14.copyWith(height: 1.2),
                  ),
                  6.h.spaceVertical,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${product.price.formattedAmount}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styleW700S16.copyWith(
                            color: AppColors.primaryDeep,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.star_rounded,
                        size: 14.h,
                        color: AppColors.champagne,
                      ),
                      2.w.spaceHorizontal,
                      Text(
                        product.rating.toStringAsFixed(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleW500S14.copyWith(color: AppColors.text06),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
