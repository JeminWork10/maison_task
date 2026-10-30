import 'package:minimalist_store/store_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (c) => AuthProvider(),
      child: const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _brandFade;
  late final Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _brandFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthProvider>();
    final usernameError = context.watch<AuthProvider>().usernameError;
    final passwordError = context.watch<AuthProvider>().passwordError;
    final obscurePassword = context.watch<AuthProvider>().obscurePassword;
    final isSubmitting = context.watch<AuthProvider>().isSubmitting;

    return Scaffold(
      body: AppPageBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppConstants.horizontalPadding,
              28.h,
              AppConstants.horizontalPadding,
              32.h,
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: _brandFade,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName.toUpperCase(),
                            style: styleEyebrow.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 4,
                            ),
                          ),
                          18.h.spaceVertical,
                          Text(
                            'Welcome\nback',
                            style: styleDisplayS42.copyWith(
                              color: AppColors.primaryDeep,
                            ),
                          ),
                          12.h.spaceVertical,
                          Text(
                            'Sign in to browse a curated catalog of essentials.',
                            style: styleW400S14.copyWith(
                              color: AppColors.text06,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    36.h.spaceVertical,
                    SlideTransition(
                      position: _formSlide,
                      child: FadeTransition(
                        opacity: _controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              header: 'Username',
                              hintText: 'emilys',
                              controller: state.usernameController,
                              error: usernameError,
                              textInputAction: TextInputAction.next,
                              onChanged: state.onUsernameChanged,
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.primary.withValues(alpha: 0.7),
                              ),
                            ),
                            16.h.spaceVertical,
                            AppTextField(
                              header: 'Password',
                              hintText: '••••••••',
                              controller: state.passwordController,
                              error: passwordError,
                              obscureText: obscurePassword,
                              textInputAction: TextInputAction.done,
                              onChanged: state.onPasswordChanged,
                              onSubmitted: (_) => state.onLoginTap(context),
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.primary.withValues(alpha: 0.7),
                              ),
                              suffixIcon: IconButton(
                                onPressed: state.toggleObscurePassword,
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.text06,
                                ),
                              ),
                            ),
                            14.h.spaceVertical,
                            Text(
                              'Demo · ${ApiConstants.testUsername} / ${ApiConstants.testPassword}',
                              style: styleW400S12.copyWith(
                                color: AppColors.grey2,
                                letterSpacing: 0.2,
                              ),
                            ),
                            28.h.spaceVertical,
                            CommonButton(
                              title: 'Enter Maison',
                              isLoading: isSubmitting,
                              onTap: () => state.onLoginTap(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
