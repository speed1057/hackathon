import 'package:flutter/material.dart';

class WhiteLabelConfig {
  final String organizationId;
  final String organizationName;
  final String appTitle;
  final Color primaryColor;
  final Color secondaryColor;
  final String? logoAssetPath;
  final String? logoUrl;
  final Color? surfaceColor;
  final Color? backgroundColor;

  const WhiteLabelConfig({
    required this.organizationId,
    required this.organizationName,
    required this.appTitle,
    required this.primaryColor,
    required this.secondaryColor,
    this.logoAssetPath,
    this.logoUrl,
    this.surfaceColor,
    this.backgroundColor,
  });

  // Default hackathon theme config - Modern design
  static const WhiteLabelConfig defaultConfig = WhiteLabelConfig(
    organizationId: 'hackathon-hub',
    organizationName: 'Hackathon Hub',
    appTitle: 'Hackathon Hub',
    primaryColor: Color(0xFF6366F1), // Modern Indigo
    secondaryColor: Color(0xFF8B5CF6), // Purple
    surfaceColor: Color(0xFF1F2937), // Dark Gray
    backgroundColor: Color(0xFF111827), // Very Dark Gray
  );

  // Predefined organization configurations - Modern color schemes
  static const Map<String, WhiteLabelConfig> predefinedConfigs = {
    'iith': WhiteLabelConfig(
      organizationId: 'iith',
      organizationName: 'IIT Hyderabad',
      appTitle: 'IITH Hackathon Hub',
      primaryColor: Color(0xFFEF4444), // Modern Red
      secondaryColor: Color(0xFFF97316), // Orange
      surfaceColor: Color(0xFF1F2937),
      backgroundColor: Color(0xFF111827),
    ),
    'iitb': WhiteLabelConfig(
      organizationId: 'iitb',
      organizationName: 'IIT Bombay',
      appTitle: 'IITB Hackathon Hub',
      primaryColor: Color(0xFF3B82F6), // Modern Blue
      secondaryColor: Color(0xFF06B6D4), // Cyan
      surfaceColor: Color(0xFF1F2937),
      backgroundColor: Color(0xFF111827),
    ),
    'stanford': WhiteLabelConfig(
      organizationId: 'stanford',
      organizationName: 'Stanford University',
      appTitle: 'Stanford Hackathon Hub',
      primaryColor: Color(0xFFDC2626), // Cardinal Red
      secondaryColor: Color(0xFFEF4444), // Light Red
      surfaceColor: Color(0xFF1F2937),
      backgroundColor: Color(0xFF1A0A0A),
    ),
    'mit': WhiteLabelConfig(
      organizationId: 'mit',
      organizationName: 'MIT',
      appTitle: 'MIT Hackathon Hub',
      primaryColor: Color(0xFFA31F34), // MIT Red
      secondaryColor: Color(0xFF8A8B8C), // MIT Gray
      surfaceColor: Color(0xFF2A1B1D),
      backgroundColor: Color(0xFF1A1012),
    ),
    'google': WhiteLabelConfig(
      organizationId: 'google',
      organizationName: 'Google',
      appTitle: 'Google Hackathon Hub',
      primaryColor: Color(0xFF4285F4), // Google Blue
      secondaryColor: Color(0xFF34A853), // Google Green
      surfaceColor: Color(0xFF1A1F2E),
      backgroundColor: Color(0xFF121212),
    ),
  };

  // Create a custom config or return predefined one
  static WhiteLabelConfig getConfig(String? orgId) {
    if (orgId == null || orgId.isEmpty) {
      return defaultConfig;
    }

    return predefinedConfigs[orgId.toLowerCase()] ?? defaultConfig;
  }

  // Create modern Material 3 theme data
  ThemeData createThemeData() {
    final surface = surfaceColor ?? const Color(0xFF1F2937);
    final background = backgroundColor ?? const Color(0xFF111827);
    const white = Color(0xFFF9FAFB);
    const gray = Color(0xFF6B7280);
    final cardSurface = Color.alphaBlend(
      primaryColor.withValues(alpha: 0.05),
      surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'SF Pro Display', // Modern font
      // Modern color scheme
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surface,
        onPrimary: white,
        onSecondary: white,
        onSurface: white,
        error: const Color(0xFFEF4444),
        onError: white,
        outline: gray,
        outlineVariant: gray.withValues(alpha: 0.2),
        surfaceContainerHighest: cardSurface,
        onSurfaceVariant: white.withValues(alpha: 0.8),
      ),

      // Scaffold theme
      scaffoldBackgroundColor: background,

      // Modern AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: white, size: 24),
        surfaceTintColor: Colors.transparent,
      ),

      // Modern Card theme
      cardTheme: CardThemeData(
        color: cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: gray.withValues(alpha: 0.1), width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Modern Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        labelStyle: TextStyle(color: Colors.grey[300]),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        labelStyle: const TextStyle(color: white),
        secondaryLabelStyle: TextStyle(color: background),
        selectedColor: secondaryColor,
        disabledColor: Colors.grey[800],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // FAB theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: background,
      ),

      // List tile theme
      listTileTheme: ListTileThemeData(
        textColor: white,
        iconColor: white,
        tileColor: surface,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: white, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: white, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: white, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: white, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: white, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: white, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: white, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: white, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: white, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: white),
        bodyMedium: TextStyle(color: white),
        bodySmall: TextStyle(color: white),
        labelLarge: TextStyle(color: white, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: white),
        labelSmall: TextStyle(color: white),
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: white),

      // Divider theme
      dividerTheme: DividerThemeData(color: Colors.grey[700], thickness: 1),

      // Snack bar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface,
        contentTextStyle: const TextStyle(color: white),
        actionTextColor: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WhiteLabelConfig &&
          runtimeType == other.runtimeType &&
          organizationId == other.organizationId;

  @override
  int get hashCode => organizationId.hashCode;
}
