import 'package:minimalist_store/store_app.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  static const String routeName = '/unknown';

  static Widget builder(BuildContext context) {
    return const UnknownScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Text('Page not found', style: styleW700S22),
      ),
    );
  }
}
