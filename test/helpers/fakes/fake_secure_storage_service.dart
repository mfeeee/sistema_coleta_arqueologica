import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sistema_coleta_arqueologica/core/services/secure_storage_service.dart';

class FakeSecureStorageService extends SecureStorageService {
  FakeSecureStorageService() : super(const FlutterSecureStorage());

  String? _token;

  @override
  Future<void> saveJwt(String token) async => _token = token;

  @override
  Future<String?> getJwt() async => _token;

  @override
  Future<void> clearAll() async => _token = null;
}
