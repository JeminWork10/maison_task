import 'package:minimalist_store/store_app.dart';

class RouteService {
  static String get initialRoute => SplashScreen.routeName;

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          builder: SplashScreen.builder,
          settings: settings,
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: LoginScreen.builder,
          settings: settings,
        );
      case ProductsScreen.routeName:
        return MaterialPageRoute(
          builder: ProductsScreen.builder,
          settings: settings,
        );
      case ProductDetailsScreen.routeName:
        return MaterialPageRoute(
          builder: ProductDetailsScreen.builder,
          settings: settings,
        );
      case UnknownScreen.routeName:
        return MaterialPageRoute(
          builder: UnknownScreen.builder,
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: UnknownScreen.builder,
          settings: settings,
        );
    }
  }
}
