// lib/data/datasources/local/preferences_manager.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart'; // Para chaves de preferências

abstract class IPreferencesManager {
  Future<bool> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<bool> saveInt(String key, int value);
  Future<int?> getInt(String key);
  Future<bool> remove(String key);
  Future<bool> clearAll();

  // Exemplo específico para tema
  Future<bool> saveThemeMode(String themeModeString);
  Future<String?> getThemeMode();
}

class PreferencesManager implements IPreferencesManager {
  // Não é necessário injetar SharedPreferences se você sempre obtém a instância.
  // Mas para testes, poderia ser injetado.
  // final SharedPreferences _sharedPreferences;
  // PreferencesManager(this._sharedPreferences);

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<bool> saveString(String key, String value) async {
    final prefs = await _prefs;
    return prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  @override
  Future<bool> saveBool(String key, bool value) async {
    final prefs = await _prefs;
    return prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  @override
  Future<bool> saveInt(String key, int value) async {
    final prefs = await _prefs;
    return prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  @override
  Future<bool> remove(String key) async {
    final prefs = await _prefs;
    return prefs.remove(key);
  }

  @override
  Future<bool> clearAll() async {
    final prefs = await _prefs;
    return prefs.clear();
  }

  // --- Métodos Específicos de Exemplo ---
  @override
  Future<bool> saveThemeMode(String themeModeString) async {
    return saveString(AppConstants.prefsKeyThemeMode, themeModeString);
  }

  @override
  Future<String?> getThemeMode() async {
    return getString(AppConstants.prefsKeyThemeMode);
  }
}
