import 'dart:math';

import 'package:minimalist_store/store_app.dart';

class AppColors {
  /// Deep wine — brand primary
  static const Color primary = Color(0xFF6B001B);
  static const Color primaryDeep = Color(0xFF3D0010);
  static const Color primarySoft = Color(0xFF8A1A36);

  static const Color text = Color(0xFF1A1215);
  static Color text08 = text.withValues(alpha: 0.8);
  static Color text06 = text.withValues(alpha: 0.6);
  static Color text01 = text.withValues(alpha: 0.1);
  static Color text02 = text.withValues(alpha: 0.2);

  /// Warm parchment with atmosphere (not flat grey)
  static const Color bg = Color(0xFFF5F0EB);
  static const Color bgWash = Color(0xFFE8DDD4);
  static const Color surface = Color(0xFFFFFCF9);
  static const Color surfaceMuted = Color(0xFFEEE6DE);

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFD71E23);
  static const Color green = Color(0xFF1B9E4B);
  static const Color grey = Color(0xFF5C5F68);
  static const Color grey2 = Color(0xFF949494);
  static const Color champagne = Color(0xFFC4A574);
  static const Color gold = Color(0xFFC4A574);

  static LinearGradient get brandHeroGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDeep, primary, primarySoft],
    stops: [0.0, 0.45, 1.0],
  );

  static LinearGradient get pageAtmosphere => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      bgWash.withValues(alpha: 0.55),
      bg,
      surface.withValues(alpha: 0.9),
    ],
    stops: const [0.0, 0.35, 1.0],
  );

  static MaterialColor generateMaterialColor() {
    return MaterialColor(primary.hashCode, {
      50: tintColor(primary, 0.9),
      100: tintColor(primary, 0.8),
      200: tintColor(primary, 0.6),
      300: tintColor(primary, 0.4),
      400: tintColor(primary, 0.2),
      500: primary,
      600: shadeColor(primary, 0.1),
      700: shadeColor(primary, 0.2),
      800: shadeColor(primary, 0.3),
      900: shadeColor(primary, 0.4),
    });
  }

  static Color tintColor(Color color, double factor) {
    return Color.fromARGB(
      _extractAlpha(color),
      _adjust(color.hashCode >> 16, factor, tint: true),
      _adjust(color.hashCode >> 8, factor, tint: true),
      _adjust(color.hashCode, factor, tint: true),
    );
  }

  static Color shadeColor(Color color, double factor) {
    return Color.fromARGB(
      _extractAlpha(color),
      _adjust(color.hashCode >> 16, factor, tint: false),
      _adjust(color.hashCode >> 8, factor, tint: false),
      _adjust(color.hashCode, factor, tint: false),
    );
  }

  static int _extractAlpha(Color color) => (color.hashCode >> 24) & 0xFF;

  static int _adjust(int value, double factor, {required bool tint}) {
    final channel = value & 0xFF;
    if (tint) {
      return max(0, min((channel + ((255 - channel) * factor)).round(), 255));
    }
    return max(0, min(channel - (channel * factor).round(), 255));
  }

  static ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: surface,
    ),
    primarySwatch: generateMaterialColor(),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
  );
}
