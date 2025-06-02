// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Cores Primárias (Exemplo - Tema Azul)
  static const Color primary = Color(0xFF0D47A1); // Azul Escuro Principal
  static const Color primaryLight = Color(0xFF1976D2); // Azul Médio
  static const Color primaryDark = Color(0xFF002171); // Azul Bem Escuro

  // Cores Secundárias (Exemplo - Laranja para destaque)
  static const Color secondary = Color(0xFFFFA000); // Laranja Âmbar
  static const Color secondaryLight = Color(0xFFFFC107); // Laranja Claro
  static const Color secondaryDark = Color(0xFFF57C00); // Laranja Escuro

  // Cores de Acento (Pode ser uma das secundárias ou uma terceira cor)
  static const Color accent = Color(0xFFFF5252); // Vermelho para acentos/ações importantes

  // Cores de Fundo
  static const Color backgroundLight = Color(0xFFF5F5F5); // Fundo claro (ex: tema claro)
  static const Color backgroundDark = Color(0xFF121212); // Fundo escuro (ex: tema escuro)
  static const Color surfaceLight = Color(0xFFFFFFFF); // Superfície de cards, diálogos (tema claro)
  static const Color surfaceDark = Color(0xFF1E1E1E); // Superfície de cards, diálogos (tema escuro)

  // Cores de Texto
  static const Color textPrimaryLight = Color(0xFF212121); // Texto principal em fundos claros
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // Texto principal em fundos escuros
  static const Color textSecondaryLight = Color(0xFF757575); // Texto secundário/hint em fundos claros
  static const Color textSecondaryDark = Color(0xFFBDBDBD); // Texto secundário/hint em fundos escuros

  // Cores de Feedback
  static const Color success = Color(0xFF4CAF50); // Verde para sucesso
  static const Color warning = Color(0xFFFFC107); // Amarelo para avisos
  static const Color error = Color(0xFFF44336); // Vermelho para erros
  static const Color info = Color(0xFF2196F3); // Azul para informações

  // Cores Neutras
  static const Color greyLight = Color(0xFFE0E0E0); // Cinza claro
  static const Color greyMedium = Color(0xFF9E9E9E); // Cinza médio
  static const Color greyDark = Color(0xFF424242); // Cinza escuro
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Cores Específicas de Status (Exemplo)
  static const Color statusActive = success;
  static const Color statusInactive = greyMedium;
  static const Color statusPending = warning;
  static const Color statusCompleted = primaryLight;
  static const Color statusTerminated = error;
  static const Color statusExpired = Color(0xFF795548); // Marrom para expirado

  // Previne instanciação
  AppColors._();
}
