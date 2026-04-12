import 'package:soilreport/src/core/caching/cache_database.dart';
import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/core/data/scoped_access_model.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import '../../../core/data/rest_service.dart';
import 'package:soilreport/src/core/data/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class AuthorizedClientPortalService extends RestService {
  SecureStorage secureStorage;
  AuthRepository auth;
  AuthorizedClientPortalService( this.secureStorage, this.auth, CacheDatabase cache, Dio dio) : super(cache, dio){
    authorizationHeaderDelegate = getBearerToken;
    authorizationHandlerDelegate = getRefreshToken;
  }

  Future getRefreshToken() async {
    ScopedAccessModel oldAccessModel = secureStorage.currentScope;
    if(oldAccessModel.hasAccess){
      await auth.renewAccessTokenAsync(oldAccessModel.refreshToken!);
      return;
    }
    await auth.signOut();
  }
  String? getBearerToken() => secureStorage.currentScope.accessToken ;

}

@Riverpod(keepAlive: true)
AuthorizedClientPortalService authorizedClientPortalService(Ref ref) {
  final cache = ref.watch(cacheDatabaseProvider);
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final auth = ref.watch(authRepositoryProvider);
  return AuthorizedClientPortalService(secureStorage, auth, cache, dio);
}