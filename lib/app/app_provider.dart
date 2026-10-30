import 'package:minimalist_store/store_app.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    init();
  }

  Locale? locale;

  void init() {
    locale = const Locale('en', 'US');
    notifyListeners();
  }
}
