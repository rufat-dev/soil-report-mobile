import 'package:soilreport/src/core/utils/theme_extensions.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static final AppTheme _instance = AppTheme._();

  factory AppTheme() {
    return _instance;
  }

  // ── Core brand palette ──────────────────────────────────────────────
  static const _primaryGreen = Color(0xFF2D6A4F);
  static const _primaryGreenLight = Color(0xFF40916C);
  static const _accent = Color(0xFFB7791F);
  static const _accentLight = Color(0xFFD4A373);
  static const _teal = Color(0xFF2B7A78);

  // ── Light surfaces ──────────────────────────────────────────────────
  static const _surfaceLight = Color(0xFFFAFAF5);
  static const _surfaceLight100 = Color(0xFFF5F2EB);
  static const _surfaceLight200 = Color(0xFFEDE9E0);
  static const _surfaceLight300 = Color(0xFFE0DCD3);
  static const _surfaceLight400 = Color(0xFFD0CBC2);

  // ── Dark surfaces ──────────────────────────────────────────────────
  static const _surfaceDark = Color(0xFF1A2332);
  static const _surfaceDark100 = Color(0xFF232E3F);
  static const _surfaceDark200 = Color(0xFF2C394B);
  static const _surfaceDark300 = Color(0xFF364559);
  static const _surfaceDark400 = Color(0xFF415268);

  // ── Semantic colors ────────────────────────────────────────────────
  static const _success = Color(0xFF38A169);
  static const _warning = Color(0xFFD69E2E);
  static const _error = Color(0xFFC53030);
  static const _info = Color(0xFF2B7A78);

  // ── Text colors ────────────────────────────────────────────────────
  static const _textDark = Color(0xFF2D3436);
  static const _textMuted = Color(0xFF636E72);
  static const _textLight = Color(0xFFE8E6E1);
  static const _textLightMuted = Color(0xFFB2BEC3);

  // ══════════════════════════════════════════════════════════════════
  //  LIGHT THEME
  // ══════════════════════════════════════════════════════════════════
  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: _primaryGreen,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFD8F3DC),
      onPrimaryContainer: Color(0xFF1B4332),
      secondary: _accent,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFFF3E0),
      onSecondaryContainer: Color(0xFF7B5E00),
      tertiary: _teal,
      onTertiary: Colors.white,
      error: _error,
      onError: Colors.white,
      surface: _surfaceLight,
      onSurface: _textDark,
      onSurfaceVariant: _textMuted,
      outline: _surfaceLight300,
      outlineVariant: _surfaceLight200,
    ),
    fontFamily: "Poppins",
    scaffoldBackgroundColor: _surfaceLight,
    textTheme: _buildTextTheme(Brightness.light),
    appBarTheme: const AppBarTheme(
      backgroundColor: _surfaceLight,
      foregroundColor: _textDark,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: _textDark,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _surfaceLight200, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryGreen,
        side: const BorderSide(color: _primaryGreen, width: 1.5),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryGreen,
        textStyle: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _surfaceLight300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _surfaceLight300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _error),
      ),
      hintStyle: const TextStyle(
        fontFamily: "Poppins",
        color: _textMuted,
        fontSize: 14,
      ),
      labelStyle: const TextStyle(
        fontFamily: "Poppins",
        color: _textMuted,
        fontSize: 14,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _surfaceLight100,
      labelStyle: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _textDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: _surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 8,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF323232),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: "Poppins",
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      actionTextColor: _primaryGreen,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: const TextStyle(
        color: _textDark,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        fontFamily: "Poppins",
      ),
      contentTextStyle: const TextStyle(
        color: _textMuted,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: "Poppins",
      ),
      iconColor: _primaryGreen,
      actionsPadding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 12),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: _surfaceLight200,
      thickness: 1,
      space: 1,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: _primaryGreen,
      unselectedLabelColor: _textMuted,
      indicatorColor: _primaryGreen,
      dividerHeight: 0,
      labelStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  // ══════════════════════════════════════════════════════════════════
  //  DARK THEME
  // ══════════════════════════════════════════════════════════════════
  final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _primaryGreenLight,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF1B4332),
      onPrimaryContainer: Color(0xFFD8F3DC),
      secondary: _accentLight,
      onSecondary: Color(0xFF3E2723),
      secondaryContainer: Color(0xFF5D4037),
      onSecondaryContainer: Color(0xFFFFE0B2),
      tertiary: Color(0xFF3AAFA9),
      onTertiary: Colors.white,
      error: Color(0xFFFC8181),
      onError: Color(0xFF3B0000),
      surface: _surfaceDark,
      onSurface: _textLight,
      onSurfaceVariant: _textLightMuted,
      outline: _surfaceDark300,
      outlineVariant: _surfaceDark200,
    ),
    fontFamily: "Poppins",
    scaffoldBackgroundColor: _surfaceDark,
    textTheme: _buildTextTheme(Brightness.dark),
    appBarTheme: const AppBarTheme(
      backgroundColor: _surfaceDark,
      foregroundColor: _textLight,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: _textLight,
      ),
    ),
    cardTheme: CardThemeData(
      color: _surfaceDark100,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _surfaceDark200, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryGreenLight,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primaryGreenLight,
        side: const BorderSide(color: _primaryGreenLight, width: 1.5),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primaryGreenLight,
        textStyle: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surfaceDark100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _surfaceDark300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _surfaceDark300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _primaryGreenLight, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFFC8181)),
      ),
      hintStyle: const TextStyle(
        fontFamily: "Poppins",
        color: _textLightMuted,
        fontSize: 14,
      ),
      labelStyle: const TextStyle(
        fontFamily: "Poppins",
        color: _textLightMuted,
        fontSize: 14,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: _surfaceDark200,
      labelStyle: const TextStyle(
        fontFamily: "Poppins",
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: _textLight,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: _surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 8,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF424242),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: "Poppins",
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      actionTextColor: _primaryGreenLight,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: _surfaceDark100,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: const TextStyle(
        color: _textLight,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        fontFamily: "Poppins",
      ),
      contentTextStyle: const TextStyle(
        color: _textLightMuted,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: "Poppins",
      ),
      iconColor: _primaryGreenLight,
      actionsPadding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 12),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: _surfaceDark200,
      thickness: 1,
      space: 1,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: _primaryGreenLight,
      unselectedLabelColor: _textLightMuted,
      indicatorColor: _primaryGreenLight,
      dividerHeight: 0,
      labelStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: "Poppins",
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  // ══════════════════════════════════════════════════════════════════
  //  TEXT THEME BUILDER
  // ══════════════════════════════════════════════════════════════════
  static TextTheme _buildTextTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final primary = isLight ? _textDark : _textLight;
    final secondary = isLight ? _textMuted : _textLightMuted;

    return TextTheme(
      displayLarge: TextStyle(fontSize: 28, color: primary, fontWeight: FontWeight.w700),
      displayMedium: TextStyle(fontSize: 22, color: primary, fontWeight: FontWeight.w600),
      displaySmall: TextStyle(fontSize: 15, color: primary, fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(fontSize: 20, color: primary, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontSize: 17, color: primary, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontSize: 15, color: primary, fontWeight: FontWeight.w500),
      titleLarge: TextStyle(fontSize: 17, color: primary, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 15, color: primary, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 15, color: primary, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16, color: primary, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, color: secondary, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12, color: secondary, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 15, color: primary, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 11, color: secondary, fontWeight: FontWeight.w500),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  HEADER STYLE
  // ══════════════════════════════════════════════════════════════════
  TextStyle get soilReportHeader => const TextStyle(
    color: _primaryGreen,
    fontWeight: FontWeight.w700,
    fontSize: 28,
  );

  // ══════════════════════════════════════════════════════════════════
  //  EXTENDED COLOR PALETTE (for direct access in widgets)
  // ══════════════════════════════════════════════════════════════════
  Color get white => const Color(0xFFFFFFFF);
  Color get black => const Color(0xFF000000);

  Color get primaryGreen => _primaryGreen;
  Color get primaryGreenLight => _primaryGreenLight;
  Color get accent => _accent;
  Color get accentLight => _accentLight;
  Color get teal => _teal;

  Color get success => _success;
  Color get warning => _warning;
  Color get error => _error;
  Color get info => _info;

  // Legacy aliases (used by existing widgets — kept for compatibility)
  Color get orange => _accent;
  Color get orangeSecondary => _accentLight;
  Color get orangeLight => const Color(0xFFFFF3E0);
  Color get orangeActivePolicies => _accent;
  Color get red => _error;
  Color get darkRed => const Color(0xFF9B2C2C);
  Color get lightGreen => _success;
  Color get darkPurple => const Color(0xFF553C9A);
  Color get lightPurple => const Color(0xFFE9D8FF);
  Color get activePolicyBackground => const Color(0xFF2D6A4F);
  Color get blueText => const Color(0xFF2C5282);

  // Surface helpers
  Color get surfaceDark => _surfaceDark;
  Color get surfaceDark900 => _surfaceDark100;
  Color get surfaceDark800 => _surfaceDark200;
  Color get surfaceDark700 => _surfaceDark300;
  Color get surfaceDark600 => _surfaceDark400;

  Color get surfaceLight => _surfaceLight;
  Color get surfaceLight900 => _surfaceLight100;
  Color get surfaceLight800 => _surfaceLight200;
  Color get surfaceLight700 => _surfaceLight300;
  Color get surfaceLight600 => _surfaceLight400;
  Color get surfaceLight500 => _surfaceDark;
  Color get lightGray => _surfaceLight100;

  Color get surveyBackground => _surfaceDark;
  Color get headerCircleDark => _surfaceDark200;
  Color get accountCardDark => _surfaceDark100;
  Color get surveySectionBackground => _surfaceDark200;
  Color get cardBorder => const Color(0x20ffffff);

  // Gray scale (legacy compatibility)
  Color get gray => _textMuted;
  Color get gray900 => const Color(0xFF1A202C);
  Color get gray800 => const Color(0xFF2D3748);
  Color get gray600 => const Color(0xFF4A5568);
  Color get gray525 => _textMuted;
  Color get gray500 => const Color(0xFF718096);
  Color get gray450 => const Color(0xFF646464);
  Color get gray400 => const Color(0xFFA0AEC0);
  Color get gray350 => const Color(0xFFB2BEC3);
  Color get gray300 => const Color(0xFFCBD5E0);
  Color get gray250 => const Color(0xFFCBD5E0);
  Color get gray200 => const Color(0xFFE2E8F0);
  Color get gray100 => const Color(0xFFEDF2F7);
  Color get gray50 => const Color(0xFFF7FAFC);

  // Status colors for domain-specific features
  Color get appStatusDraft => const Color(0xFFE2E8F0);
  Color get appStatusPendingApprove => const Color(0xFFFEFCBF);
  Color get appStatusPendingSign => const Color(0xFFBEE3F8);
  Color get appStatusInProgress => const Color(0xFFC6F6D5);
  Color get appStatusApproved => _success;
  Color get appStatusRejected => _error;

  // ══════════════════════════════════════════════════════════════════
  //  THEME-AWARE SURFACE HELPERS
  // ══════════════════════════════════════════════════════════════════
  Color gray600Theme(BuildContext context) =>
      !context.isDarkMode ? surfaceLight600 : surfaceDark600;

  Color gray700Theme(BuildContext context) =>
      !context.isDarkMode ? surfaceLight700 : surfaceDark700;

  Color gray800Theme(BuildContext context) =>
      !context.isDarkMode ? surfaceLight800 : surfaceDark800;

  Color gray900Theme(BuildContext context) =>
      !context.isDarkMode ? surfaceLight900 : surfaceDark900;

  // Card surface for the new design system
  Color cardSurface(BuildContext context) =>
      !context.isDarkMode ? Colors.white : _surfaceDark100;

  Color elevatedSurface(BuildContext context) =>
      !context.isDarkMode ? _surfaceLight100 : _surfaceDark200;

  // ══════════════════════════════════════════════════════════════════
  //  SHIMMER / SKELETON GRADIENT
  // ══════════════════════════════════════════════════════════════════
  LinearGradient shimmerGradient = const LinearGradient(
    colors: [
      Color(0xFFEDF2F7),
      Color(0xFFF7FAFC),
      Color(0xFFEDF2F7),
    ],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
