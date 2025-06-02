// lib/core/constants/app_constants.dart

class AppConstants {
  // Valores de Padding e Margin
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // BorderRadius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;

  // Durações de Animação (em milissegundos)
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 400;
  static const int animationDurationLong = 600;

  // Chaves para SharedPreferences (se usar preferences_manager.dart)
  static const String prefsKeyUserToken = 'user_token';
  static const String prefsKeyUserRole = 'user_role';
  static const String prefsKeyThemeMode = 'theme_mode';
  static const String prefsKeyUserId = 'user_id';


  // Limites
  static const int maxRecentLogsDisplay = 5; // Máximo de logs recentes a mostrar no dashboard
  static const int defaultPageSize = 20; // Para paginação, se aplicável

  // URLs (se houver URLs base fixas, embora para Supabase seja melhor via environment)
  // static const String baseUrl = 'https://api.example.com';

  // Outras constantes
  static const String defaultProfilePicAsset = 'assets/images/default_avatar.png'; // Exemplo

  // Previne instanciação
  AppConstants._();
}
