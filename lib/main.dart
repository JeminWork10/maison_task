import 'package:minimalist_store/store_app.dart';
import 'package:minimalist_store/store_app_extra.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await PrefService.init();
      AuthSession.restore();
      await ScreenUtil.ensureScreenSize();

      runApp(const AppView());
    },
    (error, stack) {
      if (kDebugMode) {
        log('error==========>>>>>>>>>\n$error');
        log('stack==========>>>>>>>>>\n$stack');
      }
    },
  );
}
