import 'package:soilreport/src/constants/cache_key.dart';
import 'package:soilreport/src/core/data/scoped_access_model.dart';
import 'package:soilreport/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/authentication/domain/access_model.dart';

part 'secure_storage.g.dart';

class SecureStorage {

  final _scopeState = InMemoryStore<ScopedAccessModel>(ScopedAccessModel());
  Stream<ScopedAccessModel> scopeStateChanges() => _scopeState.stream;
  ScopedAccessModel get currentScope => _scopeState.value;

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);
  final _storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(encryptedSharedPreferences: true),
  );

  AccessModel adminPanelAccessModel = AccessModel();
  IOSOptions _getIOSOptions() => const IOSOptions();

  Future<ScopedAccessModel> updateStateWithScopedTokens(String scope) async {
    final all = await _storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    final scopedAccess = ScopedAccessModel(
      scope: scope,
      accessToken: all["accessToken-$scope"], 
      refreshToken: all["refreshToken-$scope"],
    );
    return scopedAccess;
  }
  Future<ScopedAccessModel> readTokens(String scope) async {
    final all = await _storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return ScopedAccessModel(
      scope: scope,
      accessToken: all["accessToken-$scope"],
      refreshToken: all["refreshToken-$scope"],
    );
  }

  Future<bool> isRealScope() async => currentScope.scope == await getRealScope()
  ;

  Future writeTokens(ScopedAccessModel model) async {
    await _storage.write(key: "refreshToken-${model.scope}", value: model.refreshToken);
    await _storage.write(key: "accessToken-${model.scope}", value: model.accessToken);
    _scopeState.value = model;
  }

  Future<String?> readPasscode() async {
    final all = await _storage.readAll(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return all["passcode"];
  }

  Future writePasscode(String passcode) async {
    await _storage.write(key: "passcode", value: passcode);
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
  

  Future<String?> getRealScope() async =>
      await readSensitiveData(CacheKey.realScope);
  Future<String?> getActualScope() async =>
      await readSensitiveData(CacheKey.actualScope);
  Future setRealScope(String newRealScope) async =>
      await writeSensitiveData(CacheKey.realScope, newRealScope);
  Future setActualScope(String newScope) async {
    await writeSensitiveData(CacheKey.actualScope, newScope);
    await updateStateWithScopedTokens(newScope);
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
    _scopeState.value = ScopedAccessModel();
  }
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}
