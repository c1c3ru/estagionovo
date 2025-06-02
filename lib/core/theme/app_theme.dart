// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import '../constants/app_constants.dart'; // Para borderRadius, etc.

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primaryLight,
      primaryColorDark: AppColors.primaryDark,
      // ignore: deprecated_member_use
      // accentColor: AppColors.accent, // Deprecated, use colorScheme.secondary
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.surfaceLight,
      dividerColor: AppColors.greyLight,
      hintColor: AppColors.textSecondaryLight,
      fontFamily: AppTextStyles._baseTextStyle.fontFamily, // Usa a fonte base definida

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.black,
        error: AppColors.error,
        onError: AppColors.white,
        surface: AppColors.surfaceLight, // Era backgroundColor
        onSurface: AppColors.textPrimaryLight, // Era onBackgroundColor
        background: AppColors.backgroundLight, // Novo campo para cor de fundo principal
        onBackground: AppColors.textPrimaryLight, // Novo campo para texto sobre o fundo principal
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),

      appBarTheme: AppBarTheme(
        color: AppColors.primary,
        elevation: 2,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
      ),

      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        buttonColor: AppColors.primary,
        textTheme: ButtonTextTheme.primary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall + 4, // 12
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge), // Botões mais arredondados
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.greyMedium),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyMedium),
        prefixIconColor: AppColors.greyMedium,
      ),

      cardTheme: CardTheme(
        elevation: 1.0,
        margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),

      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.greyMedium,
        backgroundColor: AppColors.surfaceLight,
        elevation: 8.0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.greyMedium),
      ),

      // Adicione outros componentes aqui (TabBarTheme, ChipTheme, etc.)
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary, // Pode querer um primário diferente para o tema escuro
      primaryColorLight: AppColors.primaryLight,
      primaryColorDark: AppColors.primaryDark,
      // ignore: deprecated_member_use
      // accentColor: AppColors.accent,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.surfaceDark,
      dividerColor: AppColors.greyDark,
      hintColor: AppColors.textSecondaryDark,
      fontFamily: AppTextStyles._baseTextStyle.fontFamily,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight, // Um primário mais claro para tema escuro
        onPrimary: AppColors.black, // Texto sobre o primário
        secondary: AppColors.secondaryLight, // Secundário mais claro
        onSecondary: AppColors.black,
        error: AppColors.error, // Geralmente o mesmo
        onError: AppColors.black, // Texto sobre o erro
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        background: AppColors.backgroundDark,
        onBackground: AppColors.textPrimaryDark,
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.textPrimaryDark),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.textPrimaryDark),
        displaySmall: AppTextStyles.displaySmall.copyWith(color: AppColors.textPrimaryDark),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimaryDark),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: AppColors.textPrimaryDark),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimaryDark),
        titleMedium: AppTextStyles.titleMediumDark, // Usa a variação para tema escuro
        titleSmall: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium: AppTextStyles.bodyMediumDark, // Usa a variação para tema escuro
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimaryDark),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimaryDark),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimaryDark),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimaryDark),
      ),

      appBarTheme: AppBarTheme(
        color: AppColors.surfaceDark, // AppBar mais escura no tema escuro
        elevation: 0, // Sem elevação para um look mais flat
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimaryDark),
      ),

      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        buttonColor: AppColors.primaryLight, // Botão com cor primária mais clara
        textTheme: ButtonTextTheme.primary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.black, // Texto escuro sobre botão claro
          textStyle: AppTextStyles.button,
           padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall + 4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
           textStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.greyDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.greyMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2.0),
        ),
         errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyMedium),
        prefixIconColor: AppColors.greyMedium,
      ),
       cardTheme: CardTheme(
        color: AppColors.surfaceDark,
        elevation: 1.0,
        margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.greyMedium,
        backgroundColor: AppColors.surfaceDark, // Ou um cinza um pouco mais escuro
        elevation: 8.0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryLight, fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.labelSmall.copyWith(color: AppColors.greyMedium),
      ),
    );
  }

  // Previne instanciação
  AppTheme._();
}
