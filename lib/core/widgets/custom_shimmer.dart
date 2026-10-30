import 'package:minimalist_store/store_app.dart';

class CustomShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;

  const CustomShimmer({super.key, this.height, this.width, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedHeight = _finiteSize(height, constraints.maxHeight);
        final resolvedWidth = _finiteSize(
          width,
          constraints.maxWidth,
          fallback: resolvedHeight,
        );
        final boxHeight = resolvedHeight ?? resolvedWidth;
        final boxWidth = resolvedWidth ?? resolvedHeight;
        if (boxHeight == null || boxWidth == null) {
          return const SizedBox.shrink();
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          child: Shimmer.fromColors(
            baseColor: AppColors.primary.withValues(alpha: 0.1),
            highlightColor: AppColors.primary.withValues(alpha: 0),
            child: SizedBox(
              height: boxHeight,
              width: boxWidth,
              child: const ColoredBox(color: AppColors.black),
            ),
          ),
        );
      },
    );
  }

  double? _finiteSize(
    double? requested,
    double maxConstraint, {
    double? fallback,
  }) {
    if (_usable(requested)) return requested;
    if (_usable(maxConstraint)) return maxConstraint;
    if (_usable(fallback)) return fallback;
    return null;
  }

  bool _usable(double? value) =>
      value != null && value > 0 && value.isFinite && value < double.maxFinite;
}
