import 'package:soilreport/src/constants/cache_key.dart';
import 'package:soilreport/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/authentication/domain/access_model.dart';

part 'secure_storage.g.dart';

class SecureStorage {

  final _tokenState = InMemoryStore<AccessModel>(AccessModel());
  Stream<AccessModel> tokenStateChanges() => _tokenState.stream;
  AccessModel get currentTokens => _tokenState.value;

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);
  final _storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(encryptedSharedPreferences: true),
  );

  AccessModel adminPanelAccessModel = AccessModel();
  IOSOptions _getIOSOptions() => const IOSOptions();

  Future<AccessModel> readTokens() async {
    final all = await _storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    final model = AccessModel(
      accessToken: all["accessToken"],
      refreshToken: all["refreshToken"],
    );
    _tokenState.value = model;
    return model;
  }

  bool get hasRefreshToken => (currentTokens.refreshToken ?? '').trim().isNotEmpty;

  Future writeTokens(AccessModel model) async {
    await _storage.write(
      key: "refreshToken",
      value: model.refreshToken,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    await _storage.write(
      key: "accessToken",
      value: model.accessToken,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    _tokenState.value = model;
  }

  Future<String?> readAdminPanelAccessToken() async {
    final token = await _storage.read(
      key: CacheKey.mobileAdminPanelToken,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    adminPanelAccessModel.accessToken = token;
    return token;
  }

  Future writeAdminPanelAccessToken(String value) async {
    adminPanelAccessModel.accessToken = value;
    await _storage.write(
      key: CacheKey.mobileAdminPanelToken,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }
  

  Future writeSensitiveData(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> readSensitiveData(String key) async {
    final value = await _storage.read(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return value;
  }

  Future deleteAll() async {
    await _storage.deleteAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    _tokenState.value = AccessModel();
  }
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}
