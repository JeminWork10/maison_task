import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

void showCustomToast(String msg, {bool error = false}) {
  final Color accent = error ? AppColors.red : AppColors.primary;

  Widget widget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48.h,
            width: 5.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [accent, accent.withValues(alpha: 0.6)],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(6.w),
            margin: EdgeInsets.only(left: 10.w, right: 12.w),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              error ? Icons.close_rounded : Icons.check_rounded,
              size: 18.h,
              color: accent,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error ? 'Error' : 'Success',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styleW600S14,
                ),
                4.h.spaceVertical,
                Text(
                  msg,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: styleW400S12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showToastWidget(
    widget(),
    duration: const Duration(seconds: 3),
    handleTouch: true,
    dismissOtherToast: true,
    position: ToastPosition(
      align: Alignment.topCenter,
      offset: Platform.isAndroid ? 40 : 70,
    ),
  );
}
