import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimalist_store/app/app_view.dart';
import 'package:minimalist_store/core/widgets/loaders.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    isLoaderDialogOpen = false;
  });

  testWidgets(
    'closeLoaderDialog is a no-op after stack replace',
    (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (context, child) => child!,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Home')),
            routes: {
              '/products': (_) => const Scaffold(body: Text('Products')),
            },
          ),
        ),
      );
      await tester.pump();

      startLoaderDialog();
      await tester.pump();
      expect(isLoaderDialogOpen, isTrue);

      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        '/products',
        (route) => false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // After replace, only Products remains — closing loader must not crash
      // or pop that last route (old login bug).
      expect(navigatorKey.currentState!.canPop(), isFalse);
      closeLoaderDialog();
      await tester.pump();

      expect(find.text('Products'), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(isLoaderDialogOpen, isFalse);
    },
  );
}
