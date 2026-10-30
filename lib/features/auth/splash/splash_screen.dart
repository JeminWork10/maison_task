import 'package:minimalist_store/store_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider<SplashProvider>(
      create: (c) => SplashProvider(),
      child: const SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _initialized = false;
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.86, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SplashProvider>().redirectToNext(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.brandHeroGradient),
          child: Stack(
            children: [
              Positioned(
                top: -40.h,
                left: -30.w,
                child: Container(
                  width: 180.w,
                  height: 180.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.champagne.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: 80.h,
                right: -50.w,
                child: Container(
                  width: 220.w,
                  height: 220.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return FadeTransition(
                      opacity: _fade,
                      child: ScaleTransition(
                        scale: _scale,
                        child: SlideTransition(
                          position: _slide,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'M',
                                style: styleDisplayS48.copyWith(
                                  color: AppColors.champagne,
                                  fontSize: 64.sp,
                                ),
                              ),
                              8.h.spaceVertical,
                              Text(
                                AppConstants.appName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: styleEyebrow.copyWith(
                                  color: AppColors.white,
                                  letterSpacing: 6,
                                  fontSize: 14.sp,
                                ),
                              ),
                              10.h.spaceVertical,
                              Text(
                                AppConstants.appTagline,
                                style: styleW400S14.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.72),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
