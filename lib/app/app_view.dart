import 'package:minimalist_store/store_app.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: ScreenUtilInit(
        designSize: AppConstants.figmaSize,
        minTextAdapt: true,
        splitScreenMode: true,
        // Keep MaterialApp / providers stable across ScreenUtil rebuilds so the
        // navigator history is never recreated mid-session.
        builder: (context, child) {
          AppConstants.deviceHeight = MediaQuery.sizeOf(context).height;
          AppConstants.deviceWidth = MediaQuery.sizeOf(context).width;
          AppConstants.safeAreaPadding = MediaQuery.paddingOf(context);
          AppConstants.horizontalPadding = 20.w;
          return child!;
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<AppProvider>(create: (c) => AppProvider()),
            ChangeNotifierProvider<NetworkProvider>(
              lazy: false,
              create: (c) => NetworkProvider(),
            ),
          ],
          child: OKToast(
            child: MaterialApp(
              theme: AppColors.themeData,
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: kDebugMode,
              title: AppConstants.appName,
              initialRoute: RouteService.initialRoute,
              onGenerateRoute: RouteService.onGenerateRoute,
              builder: (context, child) => MediaQuery.withNoTextScaling(
                child: child ?? const SizedBox(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
