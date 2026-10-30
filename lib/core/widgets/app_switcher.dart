import 'package:minimalist_store/store_app.dart';

class AppSwitcher extends StatelessWidget {
  const AppSwitcher({
    super.key,
    required this.switchKey,
    required this.child,
    this.fill = false,
    this.duration = const Duration(milliseconds: 350),
  });

  final Object switchKey;
  final Widget child;
  final bool fill;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: _fadeScaleTransition,
      layoutBuilder: fill ? _fillLayout : AnimatedSwitcher.defaultLayoutBuilder,
      child: KeyedSubtree(key: ValueKey<Object>(switchKey), child: child),
    );
  }

  static Widget _fillLayout(
    Widget? currentChild,
    List<Widget> previousChildren,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [...previousChildren, ?currentChild],
    );
  }
}

Widget _fadeScaleTransition(Widget child, Animation<double> animation) {
  return FadeTransition(
    opacity: animation,
    child: ScaleTransition(
      scale: Tween<double>(begin: 0.98, end: 1).animate(animation),
      child: child,
    ),
  );
}
