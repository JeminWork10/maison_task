import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimalist_store/core/theme/app_colors.dart';
import 'package:minimalist_store/core/widgets/common_button.dart';
import 'package:minimalist_store/core/widgets/status_views.dart';

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, _) {
      return MaterialApp(
        theme: AppColors.themeData,
        home: Scaffold(body: child),
      );
    },
  );
}

void main() {
  testWidgets('CommonButton displays text and triggers callback', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      _wrap(
        CommonButton(
          title: 'Sign In',
          onTap: () {
            tapped = true;
          },
        ),
      ),
    );

    expect(find.text('Sign In'), findsOneWidget);
    await tester.tap(find.text('Sign In'));
    expect(tapped, isTrue);
  });

  testWidgets('CommonButton shows a spinner when loading', (tester) async {
    await tester.pumpWidget(
      _wrap(
        CommonButton(
          title: 'Sign In',
          isLoading: true,
          onTap: () {},
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Sign In'), findsNothing);
  });

  testWidgets('EmptyView displays title, message and action', (tester) async {
    var actionTriggered = false;

    await tester.pumpWidget(
      _wrap(
        EmptyView(
          title: 'No products found',
          message: 'Check back later',
          buttonText: 'Reset',
          onButtonPressed: () {
            actionTriggered = true;
          },
        ),
      ),
    );

    expect(find.text('No products found'), findsOneWidget);
    expect(find.text('Check back later'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    expect(actionTriggered, isTrue);
  });
}
