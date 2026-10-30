import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist_store/store_app.dart';

TextStyle _ui(FontWeight weight, double size, {double? letterSpacing}) =>
    GoogleFonts.plusJakartaSans(
      color: AppColors.text,
      fontSize: size.sp,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: weight,
      height: 1.25,
    );

TextStyle _display(FontWeight weight, double size, {double? letterSpacing}) =>
    GoogleFonts.fraunces(
      color: AppColors.text,
      fontSize: size.sp,
      letterSpacing: letterSpacing ?? -0.4,
      fontWeight: weight,
      height: 1.15,
    );

/// UI / body
final styleW400S12 = _ui(FontWeight.w400, 12);
final styleW400S14 = _ui(FontWeight.w400, 14);
final styleW400S16 = _ui(FontWeight.w400, 16);
final styleW500S14 = _ui(FontWeight.w500, 14);
final styleW500S16 = _ui(FontWeight.w500, 16);
final styleW500S18 = _ui(FontWeight.w500, 18);
final styleW600S12 = _ui(FontWeight.w600, 12, letterSpacing: 0.6);
final styleW600S14 = _ui(FontWeight.w600, 14);
final styleW600S16 = _ui(FontWeight.w600, 16);
final styleW700S14 = _ui(FontWeight.w700, 14);
final styleW700S16 = _ui(FontWeight.w700, 16);
final styleW700S18 = _ui(FontWeight.w700, 18);
final styleW700S22 = _ui(FontWeight.w700, 22);
final styleW700S24 = _ui(FontWeight.w700, 24);
final styleW700S30 = _ui(FontWeight.w700, 30);

/// Display / brand
final styleDisplayS28 = _display(FontWeight.w600, 28);
final styleDisplayS34 = _display(FontWeight.w600, 34);
final styleDisplayS42 = _display(FontWeight.w500, 42, letterSpacing: -0.8);
final styleDisplayS48 = _display(FontWeight.w500, 48, letterSpacing: -1.0);

final styleEyebrow = _ui(
  FontWeight.w600,
  11,
  letterSpacing: 1.8,
);
