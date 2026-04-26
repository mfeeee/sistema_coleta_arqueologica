import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math' as math;

/// Responsável exclusivamente por leitura/escrita no Keystore nativo.
/// Não contém lógica de negócio — SRP puro.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  static const _keyJwt = 'jwt_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyDbPassphrase = 'db_passphrase';

  Future<void> _safeWrite(String key, String value) async {
    try {
      await _storage.write(
        key: key, 
        value: value,
        iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      );
    } catch (e, stack) {
      log('Erro ao gravar $key', error: e, stackTrace: stack, name: 'SecureStorage');
    }
  }

  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e, stack) {
      log('Erro ao ler $key', error: e, stackTrace: stack, name: 'SecureStorage');
      return null;
    }
  }

  Future<void> saveJwt(String token) => _safeWrite(_keyJwt, token);
  Future<String?> getJwt() => _safeRead(_keyJwt);

  Future<void> saveRefreshToken(String token) => _safeWrite(_keyRefreshToken, token);
  Future<String?> getRefreshToken() => _safeRead(_keyRefreshToken);

  Future<String> getOrCreateDbPassphrase() async {
    final existing = await _safeRead(_keyDbPassphrase);
    if (existing != null) return existing;

    final passphrase = _generatePassphrase();
    await _safeWrite(_keyDbPassphrase, passphrase);
    
    final verified = await _safeRead(_keyDbPassphrase);
    if (verified == null) {
      throw Exception('Falha crítica: Não foi possível persistir a passphrase do banco.');
    }
    
    return verified;
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      log('Falha ao limpar storage seguro', error: e, name: 'SecureStorage');
    }
  }

  String _generatePassphrase({int length = 32}) {
    const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_+-=[]{}|;:,.<>?';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }
}