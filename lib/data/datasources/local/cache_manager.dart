// lib/data/datasources/local/cache_manager.dart
import '../../../core/errors/app_exceptions.dart'; // Para CacheFailure

abstract class ICacheManager {
  /// Salva um dado no cache com uma chave e tempo de expiração opcional.
  Future<void> saveData(String key, dynamic data, {Duration? expiresIn});

  /// Obtém um dado do cache pela chave. Retorna null se não existir ou estiver expirado.
  Future<dynamic> getData(String key);

  /// Remove um dado do cache.
  Future<void> removeData(String key);

  /// Limpa todo o cache.
  Future<void> clearAllCache();

  /// Verifica se uma chave existe e não está expirada.
  Future<bool> containsKey(String key);
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiryTime;

  _CacheEntry(this.data, this.expiryTime);

  bool get isExpired => DateTime.now().isAfter(expiryTime);
}

class InMemoryCacheManager implements ICacheManager {
  final Map<String, _CacheEntry> _cache = {};
  final Duration defaultCacheDuration;

  InMemoryCacheManager({this.defaultCacheDuration = const Duration(minutes: 15)});

  @override
  Future<void> saveData(String key, dynamic data, {Duration? expiresIn}) async {
    final expiry = DateTime.now().add(expiresIn ?? defaultCacheDuration);
    _cache[key] = _CacheEntry(data, expiry);
  }

  @override
  Future<dynamic> getData(String key) async {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired) {
      return entry.data;
    }
    // Se expirado, remove do cache
    if (entry != null && entry.isExpired) {
      _cache.remove(key);
    }
    return null; // Não encontrado ou expirado
  }

  @override
  Future<void> removeData(String key) async {
    _cache.remove(key);
  }

  @override
  Future<void> clearAllCache() async {
    _cache.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired) {
      return true;
    }
    if (entry != null && entry.isExpired) {
      _cache.remove(key); // Limpa se expirado
    }
    return false;
  }
}

// Se você precisar de cache persistente, considere usar Hive ou Sembast
// e crie uma implementação diferente de ICacheManager.
// Exemplo: HiveCacheManager, SembastCacheManager
