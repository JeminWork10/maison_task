import 'package:minimalist_store/store_app.dart';

class CommonIconButton extends StatelessWidget {
  const CommonIconButton({
    super.key,
    required this.icon,
    required this.height,
    required this.iconSize,
    this.width,
    this.onTap,
    this.iconColor,
    this.buttonColor,
    this.borderRadius,
    this.isDisabled = false,
  });

  final IconData icon;
  final double height;
  final double iconSize;
  final double? width;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? buttonColor;
  final double? borderRadius;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final boxWidth = width ?? height;
    final radius = borderRadius ?? (boxWidth < height ? boxWidth : height) / 2;

    return Container(
      width: boxWidth,
      height: height,
      decoration: BoxDecoration(
        color: buttonColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: AppSplashEffect(
        onTap: onTap,
        isDisabled: isDisabled,
        radius: radius,
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor ?? AppColors.text,
          ),
        ),
      ),
    );
  }
}
