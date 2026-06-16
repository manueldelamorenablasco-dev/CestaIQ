import 'package:flutter/material.dart';

class AppColors {
  // Primary — Verde ahorro (inspira confianza y dinero)
  static const Color primary = Color(0xFF1DB954);
  static const Color primaryDark = Color(0xFF148A3D);
  static const Color primaryLight = Color(0xFFE8F8EE);

  // Surface
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);

  // Text
  static const Color textPrimary = Color(0xFF0D1117);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Semantic
  static const Color saving = Color(0xFF1DB954);
  static const Color warning = Color(0xFFFF6B35);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Supermarket brand colors (para badges)
  static const Map<String, Color> supermarketColors = {
    'mercadona': Color(0xFF007940),
    'carrefour': Color(0xFF004A97),
    'lidl': Color(0xFF0050AA),
    'aldi': Color(0xFF00539F),
    'alcampo': Color(0xFFE30613),
    'eroski': Color(0xFFE30613),
    'dia': Color(0xFFE30613),
    'consum': Color(0xFF1A6B3A),
  };

  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x0A000000);
}

class AppTextStyles {
  static const String fontFamily = 'Inter';

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  static const TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle priceLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: -1,
  );

  static const TextStyle saving = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.saving,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: AppTextStyles.fontFamily,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.primaryLight,
          onSecondary: AppColors.primary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          background: AppColors.background,
          onBackground: AppColors.textPrimary,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          shadowColor: AppColors.divider,
          titleTextStyle: AppTextStyles.h3,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: AppTextStyles.button,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.button,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          hintStyle: AppTextStyles.bodyMedium,
          prefixIconColor: AppColors.textSecondary,
        ),
        cardTheme: CardTheme(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            fontSize: 11,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceVariant,
          selectedColor: AppColors.primaryLight,
          labelStyle: AppTextStyles.bodySmall,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
      );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: 12);
}

class AppShadows {
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
