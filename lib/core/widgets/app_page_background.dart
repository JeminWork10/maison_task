import 'package:minimalist_store/store_app.dart';

/// Soft parchment wash + faint brand orb — used behind catalog screens.
class AppPageBackground extends StatelessWidget {
  const AppPageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.bg),
        DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.pageAtmosphere),
        ),
        Positioned(
          top: -80.h,
          right: -60.w,
          child: IgnorePointer(
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40.h,
          left: -80.w,
          child: IgnorePointer(
            child: Container(
              width: 260.w,
              height: 260.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.champagne.withValues(alpha: 0.14),
                    AppColors.champagne.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
