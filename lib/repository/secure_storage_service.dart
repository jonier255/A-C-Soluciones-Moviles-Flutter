import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton para que exista una sola instancia en toda la app
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  final _storage = const FlutterSecureStorage();

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  /// Guarda el token JWT después del login
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  /// Obtiene el token guardado
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// Elimina el token (por ejemplo, al cerrar sesión)
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  /// Guarda datos adicionales del usuario (nombre, correo, rol, etc.)
  Future<void> saveUserData(Map<String, String> userData) async {
    for (final entry in userData.entries) {
      await _storage.write(key: entry.key, value: entry.value);
    }
  }

  /// Obtiene un dato específico del usuario
  Future<String?> getUserData(String key) async {
    return await _storage.read(key: key);
  }

  /// Elimina todos los datos guardados (token y perfil)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Verifica si hay sesión iniciada
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveAdminId(String id) async {
    await _storage.write(key: 'id_administrador', value: id);
  }

  Future<String?> getAdminId() async {
    String? id = await _storage.read(key: 'admin_id');
    if (id != null) {
      final normalized = id.trim().toLowerCase();
      if (normalized == 'null' || normalized.isEmpty) id = null;
    }
    if (id != null && id.isNotEmpty) return id;
    String? legacy = await _storage.read(key: 'id_administrador');
    if (legacy != null) {
      final normalized = legacy.trim().toLowerCase();
      if (normalized == 'null' || normalized.isEmpty) legacy = null;
    }
    return legacy;
  }

  Future<void> saveClienteId(String id) async {
    await _storage.write(key: 'cliente_id', value: id);
  }

  Future<String?> getClienteId() async {
    return await _storage.read(key: 'cliente_id');
  }

  Future<void> saveTechnicalId(String id) async {
    await _storage.write(key: 'id_tecnico', value: id);
  }

  Future<String?> getTechnicalId() async {
    return await _storage.read(key: 'id_tecnico');
  }
}
