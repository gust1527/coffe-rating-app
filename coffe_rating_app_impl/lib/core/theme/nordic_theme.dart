import 'package:flutter/material.dart';

class NordicColors {
  // Primary Nordic palette - earth tones
  static const Color primaryBrown = Color(0xFF8B4513);
  static const Color warmSand = Color(0xFFF5F2E8);
  static const Color charcoal = Color(0xFF2C2C2C);
  static const Color clay = Color(0xFFB8956A);
  static const Color oak = Color(0xFFD4B896);
  
  // Coffee-inspired accent colors
  static const Color coffeeBean = Color(0xFF3C2415);
  static const Color espresso = Color(0xFF4A2C2A);
  static const Color caramel = Color(0xFFED882A);
  static const Color cream = Color(0xFFFFF8E1);
  
  // Functional colors
  static const Color textPrimary = Color(0xFF181411);
  static const Color textSecondary = Color(0xFF897561);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF9F7F4);
  static const Color divider = Color(0xFFF4F2F0);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  
  // Rating colors
  static const Color ratingGold = Color(0xFFFFD700);
  static const Color ratingLight = Color(0xFFE0E0E0);
}

class NordicTypography {
  // Font families - using system fonts for now
  static const String primaryFont = 'System';
  
  // Text styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.033,
    height: 1.1,
    color: NordicColors.textPrimary,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.025,
    height: 1.2,
    color: NordicColors.textPrimary,
  );
  
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.015,
    height: 1.25,
    color: NordicColors.textPrimary,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.015,
    height: 1.3,
    color: NordicColors.textPrimary,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.015,
    height: 1.35,
    color: NordicColors.textPrimary,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: NordicColors.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: NordicColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: NordicColors.textSecondary,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.015,
    height: 1.4,
    color: NordicColors.textPrimary,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.015,
    height: 1.4,
    color: NordicColors.textSecondary,
  );
}

class NordicSpacing {
  // Base spacing unit (8px)
  static const double base = 8.0;
  
  // Spacing scale
  static const double xs = base * 0.5;    // 4px
  static const double sm = base;          // 8px
  static const double md = base * 2;      // 16px
  static const double lg = base * 3;      // 24px
  static const double xl = base * 4;      // 32px
  static const double xxl = base * 6;     // 48px
  static const double xxxl = base * 8;    // 64px
}

class NordicBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xlarge = 20.0;
  static const double card = 12.0;
  static const double button = 12.0;
}

class NordicTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: NordicColors.primaryBrown,
        brightness: Brightness.light,
        primary: NordicColors.primaryBrown,
        onPrimary: NordicColors.background,
        secondary: NordicColors.caramel,
        onSecondary: NordicColors.textPrimary,
        surface: NordicColors.background,
        onSurface: NordicColors.textPrimary,
      ),
      
      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: NordicColors.background,
        foregroundColor: NordicColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: NordicTypography.titleLarge,
        surfaceTintColor: Colors.transparent,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: NordicColors.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NordicBorderRadius.card),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NordicColors.caramel,
          foregroundColor: NordicColors.textPrimary,
          elevation: 0,
          textStyle: NordicTypography.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NordicBorderRadius.button),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: NordicSpacing.lg,
            vertical: NordicSpacing.md,
          ),
        ),
      ),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NordicColors.background,
        selectedItemColor: NordicColors.textPrimary,
        unselectedItemColor: NordicColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: NordicTypography.labelMedium,
        unselectedLabelStyle: NordicTypography.labelMedium,
      ),
      
      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: NordicColors.caramel,
        inactiveTrackColor: NordicColors.divider,
        thumbColor: NordicColors.caramel,
        overlayColor: NordicColors.caramel.withOpacity(0.1),
        valueIndicatorColor: NordicColors.charcoal,
        valueIndicatorTextStyle: NordicTypography.labelMedium.copyWith(
          color: NordicColors.background,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NordicColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NordicSpacing.md,
          vertical: NordicSpacing.md,
        ),
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: NordicColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
} 