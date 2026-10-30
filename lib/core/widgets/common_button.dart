import 'package:minimalist_store/store_app.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.title,
    required this.onTap,
    this.textColor,
    this.borderColor,
    this.buttonColor,
    this.disabledButtonColor,
    this.height,
    this.fontSize,
    this.startWidget,
    this.endWidget,
    this.fontWeight,
    this.isDisabled = false,
    this.isLoading = false,
    this.borderRadius,
  });

  final String title;
  final VoidCallback onTap;
  final bool isDisabled, isLoading;
  final Color? textColor, borderColor, buttonColor, disabledButtonColor;
  final double? height, fontSize, borderRadius;
  final Widget? startWidget, endWidget;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 2.r;
    final effectiveTextColor = textColor ?? AppColors.white;
    final buildButtonColor = isDisabled
        ? (disabledButtonColor ?? AppColors.primary.withValues(alpha: 0.4))
        : (buttonColor ?? AppColors.primary);

    return AnimatedContainer(
      duration: 300.milliseconds,
      height: height ?? 52.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: buildButtonColor,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: AppSplashEffect(
        onTap: onTap,
        isDisabled: isDisabled || isLoading,
        radius: radius,
        child: Center(
          child: AnimatedSwitcher(
            duration: 300.milliseconds,
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isLoading
                ? SizedBox(
                    key: const ValueKey('loading'),
                    height: 20.h,
                    width: 20.h,
                    child: CircularProgressIndicator(
                      color: effectiveTextColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : Padding(
                    key: const ValueKey('content'),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (startWidget != null) ...[
                          startWidget!,
                          10.w.spaceHorizontal,
                        ],
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: styleW700S14.copyWith(
                              color: effectiveTextColor,
                              fontSize: fontSize ?? 14.sp,
                              fontWeight: fontWeight,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        if (endWidget != null) ...[
                          10.w.spaceHorizontal,
                          endWidget!,
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
