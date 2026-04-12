import 'package:soilreport/src/core/caching/cache_database.dart';
import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/core/data/dio_provider.dart';
import 'package:soilreport/src/core/data/rest_service.dart';
import 'package:soilreport/src/core/utils/string_extension.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/features/authentication/domain/access_model.dart';
import 'package:soilreport/src/features/authentication/domain/mobile_admin_panel/mobile_admin_panel_token_request_model.dart';
import 'package:soilreport/src/features/authentication/domain/mobile_admin_panel/mobile_admin_panel_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mobile_admin_panel_service.g.dart';

class MobileAdminPanelService extends RestService {
  final SecureStorage _secureStorage;

  MobileAdminPanelService(
    this._secureStorage,
    CacheDatabase cache,
    Dio dio,
  ) : super(cache, dio) {
    authorizationHeaderDelegate = getBearerToken;
    authorizationHandlerDelegate = authorizationHandler;
  }

  /// Gets bearer token for authorization header
  String? getBearerToken() => _secureStorage.adminPanelAccessModel.accessToken;

  /// Handles authorization by getting new token from mobile admin panel
  Future<AccessModel> authorizationHandler() async {
    final url = 'https://YOUR_ADMIN_PANEL_URL/Authorize/tokengateway';
    
    final username = '';
    final password = '';
    
    final content = MobileAdminPanelTokenRequestModel(
      username: username,
      password: password,
    );
    
    try {
      final response = await postWithPayload<MobileAdminPanelResponseModel>(
        url,
        (data) => MobileAdminPanelResponseModel.fromJson(data),
        content.toJson(),
      );
      
      if (response.succeeded == true && response.token != null) {
        await _secureStorage.writeAdminPanelAccessToken( response.token!);
        return AccessModel(accessToken: response.token!);
      }
      return AccessModel();
    } catch (e) {
      // Handle error - could throw custom exception or log
      rethrow;
    }
  }
}

@Riverpod()
MobileAdminPanelService mobileAdminPanelService(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  final cache = ref.watch(cacheDatabaseProvider);
  final dio = ref.watch(dioProvider);
  return MobileAdminPanelService(storage, cache, dio);
}

@Riverpod()
Future<void> mobileAdminPanelAuthInitializer(Ref ref) async {
  final mobileAdminPanelService = ref.read(mobileAdminPanelServiceProvider);
  final accessModel = await mobileAdminPanelService.authorizationHandler();

  if (!accessModel.accessToken.isNullOrEmpty) {
    await ref.read(authRepositoryProvider).authorizationHandlerDelegate?.call();
     await mobileAdminPanelService.authorizationHandler();
  }
}