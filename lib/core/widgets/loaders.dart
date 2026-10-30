import 'package:minimalist_store/store_app.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.w,
      width: 60.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: AppColors.text01,
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(15.w),
      child: const CircularProgressIndicator(),
    );
  }
}

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  final double edgeOffset;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.edgeOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (onRefresh == null) return child;
    return RefreshIndicator(
      onRefresh: onRefresh!,
      edgeOffset: edgeOffset,
      backgroundColor: AppColors.white,
      color: AppColors.primary,
      strokeWidth: 4,
      child: child,
    );
  }
}

bool isLoaderDialogOpen = false;

void startLoaderDialog() {
  final navigator = navigatorKey.currentState;
  if (isLoaderDialogOpen || navigator == null) return;

  isLoaderDialogOpen = true;
  showDialog<void>(
    context: navigator.context,
    useRootNavigator: true,
    barrierDismissible: false,
    useSafeArea: false,
    barrierColor: AppColors.black.withValues(alpha: 0.5),
    builder: (context) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(child: AppLoader()),
      );
    },
  ).whenComplete(() {
    isLoaderDialogOpen = false;
  });
}

void closeLoaderDialog() {
  if (!isLoaderDialogOpen) return;

  final navigator = navigatorKey.currentState;
  if (navigator == null) {
    isLoaderDialogOpen = false;
    return;
  }

  // Only pop the loader dialog — never the only remaining page route.
  if (navigator.canPop()) {
    navigator.pop();
  } else {
    isLoaderDialogOpen = false;
  }
}
