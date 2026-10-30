import 'package:minimalist_store/store_app.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.title = 'Nothing here yet',
    this.message = 'Pull to refresh or try again later.',
    this.buttonText,
    this.onButtonPressed,
  });

  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 56.h, color: AppColors.grey2),
          16.h.spaceVertical,
          Text(
            title,
            style: styleW700S18,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          8.h.spaceVertical,
          Text(
            message,
            style: styleW400S14.copyWith(color: AppColors.text06),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            20.h.spaceVertical,
            CommonButton(title: buttonText!, onTap: onButtonPressed!),
          ],
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'Please try again.',
    this.buttonText = 'Retry',
    this.onRetry,
  });

  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 56.h, color: AppColors.red),
          16.h.spaceVertical,
          Text(
            title,
            style: styleW700S18,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          8.h.spaceVertical,
          Text(
            message,
            style: styleW400S14.copyWith(color: AppColors.text06),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          if (onRetry != null) ...[
            20.h.spaceVertical,
            CommonButton(title: buttonText, onTap: onRetry!),
          ],
        ],
      ),
    );
  }
}
