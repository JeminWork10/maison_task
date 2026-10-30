import 'package:minimalist_store/store_app.dart';

class CachedImage extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double? borderRadius;
  final Widget? errorWidget;
  final Alignment? alignment;

  const CachedImage(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.fit,
    this.borderRadius,
    this.errorWidget,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final path = ApiConstants.resolveUploadUrl(url);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: path.isEmpty
          ? _ImageErrorBox(
              height: height,
              width: width,
              errorWidget: errorWidget,
            )
          : CachedNetworkImage(
              imageUrl: path,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              alignment: alignment ?? Alignment.center,
              memCacheWidth: 600,
              errorWidget: (context, url, error) {
                return _ImageErrorBox(
                  height: height,
                  width: width,
                  errorWidget: errorWidget,
                );
              },
              progressIndicatorBuilder: (context, url, progress) {
                return CustomShimmer(height: height, width: width);
              },
            ),
    );
  }
}

class _ImageErrorBox extends StatelessWidget {
  const _ImageErrorBox({this.height, this.width, this.errorWidget});

  final double? height;
  final double? width;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ColoredBox(
        color: AppColors.text01,
        child: Center(
          child: errorWidget ??
              Icon(
                Icons.image_not_supported_outlined,
                size: 18.h,
                color: AppColors.grey2,
              ),
        ),
      ),
    );
  }
}
