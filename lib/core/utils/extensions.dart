import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

extension DateTimeExt on DateTime {
  String get toDdMmmYyyy => DateFormat('dd MMM yyyy').format(this);
}

extension StringExt on String {
  bool isEmailValid() {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(this);
  }
}

extension NumExt on num {
  Duration get milliseconds => Duration(
        microseconds: (this * Duration.microsecondsPerMillisecond).round(),
      );

  Duration get seconds =>
      Duration(milliseconds: (this * Duration.millisecondsPerSecond).round());

  Widget get spaceVertical => SizedBox(height: toDouble());

  Widget get spaceHorizontal => SizedBox(width: toDouble());
}

extension DoubleExt on double? {
  String get formattedAmount {
    final number = this;
    if (number == null) return '0';
    final formatter = NumberFormat('#,##,###.##', 'en_IN');
    if (number == number.roundToDouble()) {
      return formatter.format(number.toInt());
    }
    return formatter.format(number);
  }
}

extension BuildContextExt on BuildContext {
  NavigatorState get navigator {
    if (!mounted) return _DetachedNavigator.instance;
    final current = Navigator.maybeOf(this);
    assert(current != null, 'No Navigator found for this context.');
    return current ?? _DetachedNavigator.instance;
  }

  Object? get args => ModalRoute.of(this)?.settings.arguments;
}

class _DetachedNavigator extends NavigatorState {
  _DetachedNavigator._();

  static final _DetachedNavigator instance = _DetachedNavigator._();

  @override
  bool canPop() => false;

  @override
  void pop<T extends Object?>([T? result]) {}

  @override
  void popUntil(RoutePredicate predicate) {}

  @override
  Future<T?> push<T extends Object?>(Route<T> route) => Future<T?>.value();

  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) =>
      Future<T?>.value();

  @override
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) =>
      Future<T?>.value();
}

extension IterableExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
