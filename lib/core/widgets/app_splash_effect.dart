import 'package:minimalist_store/store_app.dart';

class AppSplashEffect extends StatelessWidget {
  const AppSplashEffect({
    super.key,
    required this.child,
    this.onTap,
    this.radius,
    this.borderRadius,
    this.isDisabled = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final double? radius;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(this.radius ?? 0);
    final canTap = !isDisabled && onTap != null;

    if (!canTap) return child;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, borderRadius: radius, child: child),
    );
  }
}
