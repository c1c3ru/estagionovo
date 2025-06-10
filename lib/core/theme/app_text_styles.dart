// lib/core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  // getter público para a família da fonte
  static String? get fontFamily => _baseTextStyle.fontFamily;

  // Estilo base para ser estendido (mantido privado)
  static final TextStyle _baseTextStyle = GoogleFonts.inter(
    color: AppColors.textPrimaryLight, // Cor padrão para tema claro
  );

  // Display
  static final TextStyle displayLarge = _baseTextStyle.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );
  static final TextStyle displayMedium = _baseTextStyle.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle displaySmall = _baseTextStyle.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  );

  // Headline
  static final TextStyle headlineLarge = _baseTextStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w500, // Um pouco mais de peso
  );
  static final TextStyle headlineMedium = _baseTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle headlineSmall = _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  // Title
  static final TextStyle titleLarge = _baseTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );
  static final TextStyle titleMedium = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Material 3 usa w500 para titleMedium
    letterSpacing: 0.15,
  );
  static final TextStyle titleSmall = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Body
  static final TextStyle bodyLarge = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  static final TextStyle bodyMedium = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
  static final TextStyle bodySmall = _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Label
  static final TextStyle labelLarge = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Material 3 usa w500 para labelLarge
    letterSpacing: 0.1,
  );
  static final TextStyle labelMedium = _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static final TextStyle labelSmall = _baseTextStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Estilos específicos para botões, etc., podem ser adicionados aqui
  static final TextStyle button = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  );

  // Adaptação para tema escuro (exemplo, pode ser feito no AppTheme)
  static TextStyle get bodyMediumDark =>
      bodyMedium.copyWith(color: AppColors.textPrimaryDark);
  static TextStyle get titleMediumDark =>
      titleMedium.copyWith(color: AppColors.textPrimaryDark);

  // Previne instanciação
  AppTextStyles._();
}
