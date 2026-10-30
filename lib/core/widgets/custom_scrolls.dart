import 'package:minimalist_store/store_app.dart';

class CustomSingleChildScroll extends StatelessWidget {
  const CustomSingleChildScroll({
    super.key,
    this.padding,
    this.physics,
    this.emptyWidget,
    this.isLoading = false,
    this.showEmpty = false,
    this.onRefresh,
    required this.child,
    this.emptyErrorMessage,
  });

  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Widget? emptyWidget;
  final bool showEmpty, isLoading;
  final Future<void> Function()? onRefresh;
  final Widget child;
  final String? emptyErrorMessage;

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: onRefresh,
      child: AppSwitcher(
        switchKey: isLoading
            ? 'loading'
            : showEmpty
            ? 'empty'
            : 'data',
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return const Center(key: ValueKey('loading'), child: AppLoader());
    }

    if (showEmpty) {
      return _refreshableEmpty(
        key: const ValueKey('empty'),
        canRefresh: onRefresh != null,
        child:
            emptyWidget ??
            Text(
              emptyErrorMessage ?? 'No data found',
              textAlign: TextAlign.center,
              style: styleW700S18.copyWith(color: AppColors.primary),
            ),
      );
    }

    return LayoutBuilder(
      key: const ValueKey('data'),
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: padding,
          physics: physics ?? const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}

Widget _refreshableEmpty({
  required Key key,
  required bool canRefresh,
  required Widget child,
  EdgeInsetsGeometry? padding,
}) {
  if (!canRefresh) return Center(key: key, child: child);

  return LayoutBuilder(
    builder: (context, constraints) {
      return ListView(
        key: key,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        ],
      );
    },
  );
}
