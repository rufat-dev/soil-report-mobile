import 'dart:convert';

import 'package:soilreport/src/core/data/scoped_access_model.dart';
import 'package:soilreport/src/features/authentication/data/mobile_admin_panel_service.dart';
import 'package:soilreport/src/features/authentication/domain/bootstrap_response_model.dart';
import 'package:soilreport/src/features/authentication/domain/bootstrap_user_request.dart';
import 'package:soilreport/src/features/authentication/domain/firebase_auth_response.dart';
import 'package:soilreport/src/features/authentication/domain/firebase_email_password_auth_request.dart';
import 'package:soilreport/src/features/authentication/domain/firebase_error_response.dart';
import 'package:soilreport/src/features/authentication/domain/firebase_lookup_request.dart';
import 'package:soilreport/src/features/authentication/domain/firebase_lookup_response.dart';
import 'package:soilreport/src/features/authentication/domain/firebase_refresh_response.dart';
import 'package:soilreport/src/features/authentication/domain/firebase_send_oob_code_request.dart';
import 'package:soilreport/src/features/authentication/domain/login_as_guest_model.dart';
import 'package:soilreport/src/features/authentication/domain/token_model.dart';
import 'package:dio/dio.dart';
import 'package:soilreport/src/constants/default_values.dart';
import 'package:soilreport/src/core/caching/cache_database.dart';
import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/core/data/rest_service.dart';
import 'package:soilreport/src/core/data/dio_provider.dart';
import 'package:soilreport/src/core/utils/string_extension.dart';
import 'package:soilreport/src/exceptions/app_exception.dart';
import 'package:soilreport/src/features/authentication/domain/token_result_model.dart';
import 'package:soilreport/src/utils/in_memory_store.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../constants/urls.dart';
import '../../../core/api_domain/operation_result_model.dart';
import '../domain/access_model.dart';
import '../domain/authentication_model.dart';
import '../domain/enums/client_type.dart';
import '../domain/enums/verification_type.dart';
import '../domain/login_model.dart';
import '../domain/password_recovery_model.dart';
import '../domain/sms_payload_model.dart';
import '../domain/user_model.dart';
import '../domain/verification_model.dart';

part 'auth_repository.g.dart';

class AuthRepository extends RestService {
  final SecureStorage _secureStorage;
  AuthRepository(
    this._secureStorage,
    CacheDatabase cache,
    Dio dio,
  ) : super(cache, dio);

  final _authState = InMemoryStore<UserModel?>(null);
  Stream<UserModel?> authStateChanges() => _authState.stream;
  UserModel? get currentUser => _authState.value;

  // ════════════════════════════════════════════════════════════════════
  //  Firebase Identity Toolkit: Sign In with Email & Password
  //  POST identitytoolkit.googleapis.com/v1/accounts:signInWithPassword
  // ════════════════════════════════════════════════════════════════════
  Future<void> getAccessTokenByTraditionalLogin(String email, String password) async {
    try {
      final payload = FirebaseEmailPasswordAuthRequest(
        email: email,
        password: password,
      );
      final response = await Dio().post<Map<String, dynamic>>(
        Urls.firebaseSignInUrl,
        data: jsonEncode(payload.toJson()),
        options: Options(contentType: 'application/json'),
      );

      if (response.data == null || response.statusCode != 200) throw UserNotFoundException();
      final authResponse = FirebaseAuthResponse.fromJson(response.data!);

      if (authResponse.idToken.isNullOrEmpty || authResponse.refreshToken.isNullOrEmpty) {
        throw SystemErrorException();
      }

      final scopedAccess = ScopedAccessModel(
        accessToken: authResponse.idToken,
        refreshToken: authResponse.refreshToken,
      );
      await _setFirebaseLoginScope(scopedAccess, authResponse);
    } on DioException catch (_) {
      throw UserNotFoundException();
    }
  }

  // ════════════════════════════════════════════════════════════════════
  //  Firebase Identity Toolkit: Register with Email & Password
  //  POST identitytoolkit.googleapis.com/v1/accounts:signUp
  // ════════════════════════════════════════════════════════════════════
  Future<FirebaseAuthResponse> registerWithEmailPassword(String email, String password) async {
    try {
      final payload = FirebaseEmailPasswordAuthRequest(
        email: email,
        password: password,
      );
      final response = await Dio().post<Map<String, dynamic>>(
        Urls.firebaseSignUpUrl,
        data: jsonEncode(payload.toJson()),
        options: Options(contentType: 'application/json'),
      );

      if (response.data == null || response.statusCode != 200) {
        throw SystemErrorException(sysMessage: 'Registration failed');
      }
      final authResponse = FirebaseAuthResponse.fromJson(response.data!);

      if (authResponse.idToken.isNullOrEmpty || authResponse.refreshToken.isNullOrEmpty) {
        throw SystemErrorException(sysMessage: 'Registration returned empty tokens');
      }

      final scopedAccess = ScopedAccessModel(
        accessToken: authResponse.idToken,
        refreshToken: authResponse.refreshToken,
      );
      await _setFirebaseLoginScope(scopedAccess, authResponse);

      return authResponse;
    } on DioException catch (ex) {
      final errorBody = ex.response?.data;
      final errorMessage = errorBody is Map<String, dynamic>
          ? FirebaseErrorResponse.fromJson(errorBody).message
          : 'Registration failed';
      throw SystemErrorException(sysMessage: errorMessage);
    }
  }

  // ════════════════════════════════════════════════════════════════════
  //  Soil Report Backend: Bootstrap User
  //  POST /auth/bootstrap (Bearer token)
  //  Called right after register to insert user into BigQuery
  // ════════════════════════════════════════════════════════════════════
  Future<BootstrapResponseModel> bootstrapUser({
    required String fullName,
    required String phoneNumber,
  }) async {
    final idToken = _secureStorage.currentScope.accessToken;
    if (idToken.isNullOrEmpty) throw UnauthorizedUserException();

    try {
      final payload = BootstrapUserRequest(
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      final response = await Dio().post<Map<String, dynamic>>(
        Urls.authBootstrapUrl,
        data: jsonEncode(payload.toJson()),
        options: Options(
          headers: {'Authorization': 'Bearer $idToken'},
          contentType: 'application/json',
        ),
      );

      if (response.data == null || response.statusCode != 200) {
        throw SystemErrorException(sysMessage: 'Bootstrap failed');
      }
      return BootstrapResponseModel.fromJson(response.data!);
    } on DioException catch (ex) {
      throw SystemErrorException(
        sysMessage: 'Bootstrap failed: ${ex.message}',
      );
    }
  }

  // ════════════════════════════════════════════════════════════════════
  //  Firebase Identity Toolkit: Lookup User
  //  POST identitytoolkit.googleapis.com/v1/accounts:lookup
  // ════════════════════════════════════════════════════════════════════
  Future<FirebaseUserRecord?> lookupUser(String idToken) async {
    try {
      final payload = FirebaseLookupRequest(idToken: idToken);
      final response = await Dio().post<Map<String, dynamic>>(
        Urls.firebaseLookupUrl,
        data: jsonEncode(payload.toJson()),
        options: Options(contentType: 'application/json'),
      );

      if (response.data == null) return null;
      final lookupResponse = FirebaseLookupResponse.fromJson(response.data!);
      return lookupResponse.users?.firstOrNull;
    } on DioException catch (_) {
      return null;
    }
  }

  // ════════════════════════════════════════════════════════════════════
  //  Firebase Identity Toolkit: Send Email Verification OTP
  //  POST identitytoolkit.googleapis.com/v1/accounts:sendOobCode
  // ════════════════════════════════════════════════════════════════════
  Future<void> sendEmailVerification(String idToken) async {
    try {
      final payload = FirebaseSendOobCodeRequest.verifyEmail(idToken);
      await Dio().post(
        Urls.firebaseSendOobCodeUrl,
        data: jsonEncode(payload.toJson()),
        options: Options(contentType: 'application/json'),
      );
    } on DioException catch (ex) {
      throw SystemErrorException(
        sysMessage: 'Failed to send email verification: ${ex.message}',
      );
    }
  }

  // ════════════════════════════════════════════════════════════════════
  //  Firebase Secure Token: Refresh ID Token
  //  POST securetoken.googleapis.com/v1/token
  //  Content-Type: application/x-www-form-urlencoded
  // ════════════════════════════════════════════════════════════════════
  Future<ScopedAccessModel> renewAccessTokenAsync(String refreshToken) async {
    try {
      final response = await Dio().post<Map<String, dynamic>>(
        Urls.firebaseRefreshTokenUrl,
        data: 'grant_type=refresh_token&refresh_token=$refreshToken',
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );

      if (response.data == null) return ScopedAccessModel();
      final refreshResponse = FirebaseRefreshResponse.fromJson(response.data!);

      if (!refreshResponse.idToken.isNullOrEmpty) {
        final scopedAccess = ScopedAccessModel(
          scope: refreshResponse.userId,
          accessToken: refreshResponse.idToken,
          refreshToken: refreshResponse.refreshToken,
        );
        await _secureStorage.writeTokens(scopedAccess);
        return scopedAccess;
      }
      return ScopedAccessModel();
    } on DioException catch (ex) {
      throw SystemErrorException(
        sysMessage: 'Token refresh failed: ${ex.message}',
      );
    }
  }

  // ════════════════════════════════════════════════════════════════════
  //  Internal: set scope from Firebase sign-in/register response
  // ════════════════════════════════════════════════════════════════════
  Future<void> _setFirebaseLoginScope(
    ScopedAccessModel access,
    FirebaseAuthResponse authResponse,
  ) async {
    try {
      final decodedToken = JwtDecoder.decode(access.accessToken!);
      final userId = decodedToken['user_id'] ?? decodedToken['sub'] ?? authResponse.localId;

      await _secureStorage.setRealScope(userId);
      await _secureStorage.setActualScope(userId);
      await _secureStorage.writeTokens(ScopedAccessModel(
        scope: userId,
        accessToken: access.accessToken,
        refreshToken: access.refreshToken,
      ));

      await getUserModelByAccessTokenAsync(access: access);
    } catch (e) {
      throw SystemErrorException(
        sysMessage: 'Exception during setFirebaseLoginScope: ${e.toString()}',
      );
    }
  }

  // ════════════════════════════════════════════════════════════════════
  //  Get User Model via Firebase Lookup
  // ════════════════════════════════════════════════════════════════════
  Future<UserModel?> getUserModelByAccessTokenAsync({ScopedAccessModel? access}) async {
    final idToken = access?.accessToken ?? _secureStorage.currentScope.accessToken;
    if (idToken.isNullOrEmpty) return null;

    final userRecord = await lookupUser(idToken!);
    if (userRecord != null) {
      final nameParts = userRecord.displayName?.split(' ');
      final user = UserModel(
        nameParts?.firstOrNull,
        nameParts != null && nameParts.length > 1
            ? nameParts.sublist(1).join(' ')
            : null,
        null,
        userRecord.phoneNumber,
        userRecord.localId ?? '',
        userRecord.displayName,
        userRecord.localId,
        null,
        userRecord.email ?? '',
        false,
        ClientType.physicalPersonCode,
        null,
        null,
      );
      _authState.value = user;
      return user;
    }
    return null;
  }

  // ════════════════════════════════════════════════════════════════════
  //  Legacy: kept for existing auth flow compatibility
  // ════════════════════════════════════════════════════════════════════

  Future<void> setLoginScope(ScopedAccessModel access) async {
    try {
      final decodedToken = JwtDecoder.decode(access.accessToken!);
      final pin = decodedToken['user_id'] ?? decodedToken['code'];
      await _secureStorage.setRealScope(pin);
      await _secureStorage.setActualScope(pin);
      await _secureStorage.writeTokens(ScopedAccessModel(
        scope: pin,
        accessToken: access.accessToken,
        refreshToken: access.refreshToken,
      ));
      await getUserModelByAccessTokenAsync(access: access);
    } catch (e) {
      throw SystemErrorException(
        sysMessage: 'Exception during setLoginScope: ${e.toString()}',
      );
    }
  }

  Future<void> getAccessTokenByGuidAsync(String guid) async {
    ScopedAccessModel access = ScopedAccessModel();
    String url = "${Urls.mainEndpoint}${Urls.clientPortalApiUrl}auth/tokenbyguid";

    final response = await rawPostResponse(
      url,
      payload: guid,
    );
    if (response.data != null && response.statusCode == 200) {
      TokenResultModel tokenResult = TokenResultModel.fromJson(response.data!);
      access.accessToken = tokenResult.accessToken;
      access.refreshToken =
          getCookieValue(response.headers["set-cookie"], "refreshToken");
      if (access.accessToken.isNullOrEmpty ||
          access.refreshToken.isNullOrEmpty) throw SystemErrorException();
      await setLoginScope(access);
      return;
    } else {
      throw UserNotFoundException();
    }
  }

  Future<bool> checkPinAsync(String pin) async {
    String url =
        "${Urls.mainEndpoint}${Urls.clientPortalApiUrl}auth/pin";
    var model = LoginModel(pin: pin);
    Map<String, dynamic>? response =
        await rawPostWithPayload(url, model.toJson());
    if (response != null) {
      OperationResultModel<AuthenticationModel> responseModel =
          OperationResultModel<AuthenticationModel>.fromJson(
              response,
              (Object? json) =>
                  AuthenticationModel.fromJson(json as Map<String, dynamic>));
      return responseModel.success;
    }
    return false;
  }

  Future<T?> loginAsGuest<T extends TokenModel>(
    LoginAsGuestModel loginAsGuest,
    T Function(dynamic json) fromJson,
  ) async {
    final url =
        "${Urls.mainEndpoint}${Urls.clientPortalApiUrl}auth/loginasguest";
    final response =
        await postWithPayload<T>(url, fromJson, loginAsGuest.toJson());
    if (response != null && !response.token.isNullOrEmpty) {
      if (_secureStorage.currentScope.refreshToken.isNullOrEmpty) {
        _secureStorage.currentScope.accessToken = response.token;
        final accessModel = ScopedAccessModel(
            scope: "guest", accessToken: response.token, refreshToken: null);
        await _secureStorage.writeTokens(accessModel);
      }
      return response;
    }
    return null;
  }

  Future<bool> loginAsGuestForSurveyUpload(String accessKey) async {
    try {
      final loginAsGuestModel = LoginAsGuestModel(
        parameters: <String, dynamic>{
          "encrypedAccessKey": accessKey,
        },
        reason: LoginAsGuestType.surveyPictureUpload,
        source: RequestSourceType.mobile,
      );
      final response = await loginAsGuest<TokenModel>(
        loginAsGuestModel,
        (json) => TokenModel.fromJson(json as Map<String, dynamic>),
      );
      return response != null && !response.token.isNullOrEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> verifyPhoneAsync(String pin, String phoneNumber) async {
    String url =
        "${Urls.mainEndpoint}${Urls.clientPortalApiUrl}auth/phone";
    final model = SmsPayloadModel(pin, phoneNumber);
    var response = await rawPostWithPayload(url, model.toJson());
    if (response != null) {
      OperationResultModel<AuthenticationModel> responseModel =
          OperationResultModel<AuthenticationModel>.fromJson(
              response,
              (Object? json) =>
                  AuthenticationModel.fromJson(json as Map<String, dynamic>));
      if (responseModel.success) {
        return;
      } else {
        throw WrongPhoneNumberException();
      }
    }
    throw NetworkIssueException();
  }

  Future<LoginModel?> checkPhoneVerificationAsync(
      String otpCode, String phoneNumber, String pin) async {
    String url =
        "${Urls.mainEndpoint}${Urls.clientPortalApiUrl}auth/verify";
    var model = VerificationModel(
        code: pin,
        verificationType: VerificationType.sms,
        phoneNumber: phoneNumber,
        smsVerificationCode: otpCode,
        emailVerificationCode: null);
    var response = await rawPostWithPayload(url, model.toJson());
    if (response != null) {
      OperationResultModel<LoginModel> responseModel =
          OperationResultModel<LoginModel>.fromJson(response,
              (Object? json) =>
                  LoginModel.fromJson(json as Map<String, dynamic>));
      if (responseModel.success) {
        return responseModel.model;
      }
    }
    return null;
  }

  Future<PasswordRecoveryModel?> setPasswordAsync(
      String pin, String password) async {
    String url =
        "${Urls.mainEndpoint}${Urls.clientPortalApiUrl}auth/setpassword";
    var model = PasswordRecoveryModel(
        pin: pin,
        password: password,
        rePassword: password,
        language: DefaultValues.defaultLanguage,
        referalCode: "");
    var response = await rawPostWithPayload(url, model.toJson());
    if (response != null) {
      OperationResultModel<PasswordRecoveryModel> responseModel =
          OperationResultModel<PasswordRecoveryModel>.fromJson(
              response,
              (Object? json) =>
                  PasswordRecoveryModel.fromJson(json as Map<String, dynamic>));
      if (responseModel.success) {
        return responseModel.model;
      }
    }
    throw CouldntSetPasswordException();
  }

  Future<String?> getAsanLoginUrlAsync() async {
    String url =
        "${Urls.mainEndpoint}${Urls.clientPortalApiUrl}asan/asanurlformobile";
    var response = await rawGet(url);
    OperationResultModel<String> responseModel =
        OperationResultModel<String>.fromJson(
            response, (Object? json) => (json as String));
    if (responseModel.success) {
      return responseModel.model;
    }
    return null;
  }

  Future<void> signOut() async {
    _authState.value = null;
    await cache.clear();
    await _secureStorage.deleteAll();
  }

  void dispose() => _authState.close();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final cache = ref.watch(cacheDatabaseProvider);
  final dio = ref.watch(dioProvider);
  final auth = AuthRepository(secureStorage, cache, dio);
  ref.onDispose(() => auth.dispose());
  return auth;
}

@Riverpod()
Future<void> authInitializer(Ref ref) async {
  final auth = ref.read(authRepositoryProvider);
  final secureStorage = ref.read(secureStorageProvider);
  final initActualScope = await secureStorage.getActualScope();
  if (initActualScope == null) return;
  final scopedAccessModel = await secureStorage.readTokens(initActualScope);
  if (scopedAccessModel.hasAccess) {
    try {
      final renewedAccessModel =
          await auth.renewAccessTokenAsync(scopedAccessModel.refreshToken!);
      if (!renewedAccessModel.accessToken.isNullOrEmpty) {
        // await auth.getUserModelByAccessTokenAsync(access: renewedAccessModel);
        // await ref.read(mobileAdminPanelAuthInitializerProvider.future);
      } else {
        await auth.signOut();
      }
    } catch (e) {
      await auth.signOut();
    }
  }
}

@Riverpod(keepAlive: true)
Stream<UserModel?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
