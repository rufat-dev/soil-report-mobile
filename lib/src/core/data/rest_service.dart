import 'dart:convert';

import 'package:soilreport/src/core/utils/string_extension.dart';
import 'package:dio/dio.dart';
import 'package:soilreport/src/core/caching/cache_database.dart';
import 'package:soilreport/src/exceptions/app_exception.dart';

class RestService{

  final CacheDatabase cache;
  final Dio? _dio;

  RestService(this.cache, [this._dio]);

  Future<void> Function()? authorizationHandlerDelegate;
  String? Function()? authorizationHeaderDelegate;

  Map<String, String> _buildHeaders(Map<String, String>? baseHeaders) {
    final headers = Map<String, String>.from(baseHeaders ?? {});
    if(headers?.containsKey("Authorization") == true && !headers["Authorization"].isNullOrEmpty){
      return headers;
    }
    final token = authorizationHeaderDelegate?.call();
    if (token != null && !token.startsWith("Bearer ")) {
      headers["Authorization"] = "Bearer $token";
    } else if (token != null) {
      headers["Authorization"] = token;
    }
    return headers;
  }

  Future<dynamic?> rawPost<TResponse>(
      String url,
      {Map<String, String>? headers,
      int recursionCounter = 1}
      ) async {
    Map<String, String> finalHeaders = _buildHeaders(headers);
    try{
      Response<dynamic> response = await (_dio ?? Dio()).post(
          url,
          options: Options(
            headers: finalHeaders,
            contentType: "application/json"
          )
      );
      if(response.data != null ) return response.data!;
      throw ApiIssueException();

    } on DioException catch (ex){
      return await refreshAccess(
        ex,
        method: 'POST',
        url: url,
        headers: headers,
        recursionCounter: recursionCounter,
      );
    }
  }
  
  Future<dynamic> rawPostWithPayload(
      String url,
      dynamic payload,
      {Map<String, String>? headers,
        int recursionCounter = 1}
      ) async {
    Map<String, String> finalHeaders = _buildHeaders(headers);
    try{
      Response<dynamic> response = await (_dio ?? Dio()).post(
          url,
          data: jsonEncode(payload),
          options: Options(
            headers: finalHeaders,
            contentType: "application/json"
          )
      );
      if(response.data != null ) return response.data!;
      throw ApiIssueException();
    } on DioException catch (ex){
      return await refreshAccess(
        ex,
        method: 'POST',
        url: url,
        headers: headers,
        payload: jsonEncode(payload),
        recursionCounter: recursionCounter,
      );
    }
  }

  Future<dynamic> rawPutWithPayload<TPayload>(
      String url,
      dynamic payload,
      {Map<String, String>? headers,
        int recursionCounter = 1}
      ) async {
    Map<String, String> finalHeaders = _buildHeaders(headers);
    try{
      Response<dynamic> response = await (_dio ?? Dio()).put(
          url,
          data: jsonEncode(payload),
          options: Options(
            headers: finalHeaders,
            contentType: "application/json"
          )
      );
      if(response.data != null ) return response.data!;
      throw ApiIssueException();
    } on DioException catch (ex){
      return await refreshAccess(
        ex,
        method: 'PUT',
        url: url,
        headers: headers,
        payload: jsonEncode(payload),
        recursionCounter: recursionCounter,
      );
    }
  }

  Future<dynamic> rawDeleteWithPayload<TPayload>(
      String url,
      dynamic payload,
      {Map<String, String>? headers,
        int recursionCounter = 1}
      ) async {

    Map<String, String> finalHeaders = _buildHeaders(headers);
    try{
      Response<dynamic> response = await (_dio ?? Dio()).delete(
          url,
          data: jsonEncode(payload),
          options: Options(
            headers: finalHeaders,
            contentType: "application/json"
          )
      );
      if(response.data != null ) return response.data!;
      throw ApiIssueException();
    } on DioException catch (ex){
      return await refreshAccess(
        ex,
        method: 'DELETE',
        url: url,
        headers: headers,
        payload: jsonEncode(payload),
        recursionCounter: recursionCounter,
      );
    }
  }

  Future<void> rawDelete(
    String url, {
    Map<String, String>? headers,
    int recursionCounter = 1,
  }) async {
    final finalHeaders = _buildHeaders(headers);
    try {
      await (_dio ?? Dio()).delete<dynamic>(
        url,
        options: Options(
          headers: finalHeaders,
          contentType: 'application/json',
        ),
      );
    } on DioException catch (ex) {
      await refreshAccess(
        ex,
        method: 'DELETE',
        url: url,
        headers: headers,
        recursionCounter: recursionCounter,
      );
    }
  }

  Future<Map<String,dynamic>> rawGet(
      String url,
      {Map<String, String>? headers,
        int recursionCounter = 1}
      ) async {

    Map<String, String> finalHeaders = _buildHeaders(headers);
    try{
      Response<Map<String,dynamic>> response = await (_dio ?? Dio()).get(
          url,
          options: Options(
              headers: finalHeaders,
              contentType: "application/json"
          )
      );
      if(response.data!=null) return response.data!;
      throw ApiIssueException();
    } on DioException catch (ex){
      return await refreshAccess(
        ex,
        method: 'GET',
        url: url,
        headers: headers,
        recursionCounter: recursionCounter,
      );
    }
  }

  /// GET where the JSON root may be a List or a Map (e.g. SoilReportFn `/alerts` returns an array).
  Future<dynamic> rawGetDynamic(
    String url, {
    Map<String, String>? headers,
    int recursionCounter = 1,
  }) async {
    final finalHeaders = _buildHeaders(headers);
    try {
      final response = await (_dio ?? Dio()).get<dynamic>(
        url,
        options: Options(
          headers: finalHeaders,
          contentType: 'application/json',
        ),
      );
      if (response.data != null) {
        return response.data;
      }
      throw ApiIssueException();
    } on DioException catch (ex) {
      return await refreshAccess(
        ex,
        method: 'GETD',
        url: url,
        headers: headers,
        recursionCounter: recursionCounter,
      );
    }
  }

  Future<List<int>?> rawGetBytes(
      String url,
      {Map<String, String>? headers,
        int recursionCounter = 1}
      ) async {

    Map<String, String> finalHeaders = _buildHeaders(headers);
    try{
      Response<List<int>> response = await (_dio ?? Dio()).get(
          url,
          options: Options(
              headers: finalHeaders,
              responseType: ResponseType.bytes
          )
      );
      if(response.data!=null && response.statusCode == 200) return response.data!;
      return null;
    } on DioException catch (ex){
      if (authorizationHandlerDelegate != null) {
        if (ex.response != null && ex.response!.statusCode == 401) {
          if (recursionCounter < 3) {
            await authorizationHandlerDelegate!();
            return await rawGetBytes(url, headers: headers, recursionCounter: ++recursionCounter);
          }
        }
      }
      return null;
    }
  }

  Future<Response<Map<String, dynamic>>> rawPostResponse(
      String url,
      {dynamic payload,
      Map<String, String>? headers,
      int recursionCounter = 1}
      ) async {
    final finalHeaders = _buildHeaders(headers);
    try {
      final response  = await (_dio ?? Dio()).post<Map<String, dynamic>>(
        url,
        data: payload == null ? null : jsonEncode(payload),
        options: Options(
          headers: finalHeaders,
          contentType: "application/json",
        ),
      );
      return response;
    } on DioException catch (ex) {
      await refreshAccess(
        ex,
        method: 'POST',
        url: url,
        headers: headers,
        payload: payload == null ? null : jsonEncode(payload),
        recursionCounter: recursionCounter,
      );
      // After successful refresh, retry once with incremented recursionCounter
      return await rawPostResponse(
        url,
        payload: payload,
        headers: headers,
        recursionCounter: recursionCounter + 1,
      );
    }
  }

  Future<TResponse> get<TResponse>(
      String url,
      TResponse Function(Map<String,dynamic>) fromJson,
      {Map<String, String>? headers,}
      ) async {
    final response = await rawGet(url, headers: headers ?? {"content-type" : "application/json"});
    try{
      return fromJson(response);
    }catch (ex){
      throw JsonParseException();
    }
  }

  Future<TResponse?> post<TResponse>(
      String url,
      TResponse Function(dynamic) fromJson,
      {Map<String, String> headers = const {"content-type" : "application/json"},}
      ) async {
    final response = await rawPost(url, headers: headers);
    if(response!=null){
      try{
        return fromJson(response);
      }catch (ex){
        throw JsonParseException();
      }
    }
    return null;
  }

  Future<TResponse> postWithPayload<TResponse>(
      String url,
      TResponse Function(dynamic) fromJson,
      dynamic payload,
      {Map<String, String> headers = const {"content-type" : "application/json"},}
    ) async {
    final response = await rawPostWithPayload(url,payload, headers: headers);
    try{
      return fromJson(response);
    } on Exception catch (_) {
      throw JsonParseException();
    }
  }

  Future<TResponse> putWithPayload<TResponse>(
      String url,
      TResponse Function(dynamic) fromJson,
      dynamic payload,
      {Map<String, String> headers = const {"content-type" : "application/json"},}
    ) async {
    final response = await rawPutWithPayload(url, payload, headers: headers);
    try{
      return fromJson(response);
    } on Exception catch (_) {
      throw JsonParseException();
    }
  }

  Future<TResponse> deleteWithPayload<TResponse>(
      String url,
      TResponse Function(dynamic) fromJson,
      dynamic payload,
      {Map<String, String> headers = const {"content-type" : "application/json"},}
    ) async {
    final response = await rawDeleteWithPayload(url, payload, headers: headers);
    try{
      return fromJson(response);
    } on Exception catch (_) {
      throw JsonParseException();
    }
  }

  Future<Response<TResponse>> delete<TResponse,TRequest>(
      String url,
      TRequest payload,
      {Map<String, String> headers = const {"content-type" : "application/json"}}
      ) async {
    Response<TResponse> response = await (_dio ?? Dio()).delete(
        url,
        data: payload,
        options: Options(
            headers: headers
        )
    );

    return response;
  }

  String? getCookieValue(List<String>? cookies, String cookieKey){
    if(cookies!=null){
      for(String cookie in cookies){
        RegExp regex = RegExp('$cookieKey=(.*?);');
        Match? match = regex.firstMatch(cookie);
        if (match != null) {
          return match.group(1)!;
        }
      }
    }
    return null;
  }

  /// Same as Dio-layer check: connection/timeout errors are handled by
  /// the Dio interceptor (redirect to auth alert). We rethrow so we don't
  /// replace with [UnauthorizedUserException].
  static bool isConnectionOrTimeout(DioException ex) {
    switch (ex.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      default:
        return false;
    }
  }

  Future refreshAccess(
      DioException ex,
      {required String method,
      required String url,
      Map<String, String>? headers,
      dynamic payload,
      int recursionCounter = 1}
      ) async {
    if (isConnectionOrTimeout(ex)) {
      throw ex;
    }
    if (authorizationHandlerDelegate != null) {
      if (ex.response != null && ex.response!.statusCode == 401) {
        if (recursionCounter < 3) {
          await authorizationHandlerDelegate!();
          switch (method) {
            case 'GET':
              return await rawGet(url, headers: headers, recursionCounter: ++recursionCounter);
            case 'GETD':
              return await rawGetDynamic(
                url,
                headers: headers,
                recursionCounter: ++recursionCounter,
              );
            case 'POST':
              if (payload != null) {
                return await rawPostWithPayload(url, payload, headers: headers, recursionCounter: ++recursionCounter);
              }
              return await rawPost(url, headers: headers, recursionCounter: ++recursionCounter);
            case 'PUT':
              if (payload != null) {
                return await rawPutWithPayload(url, payload, headers: headers, recursionCounter: ++recursionCounter);
              }
              break;
            case 'DELETE':
              if (payload != null) {
                return await rawDeleteWithPayload(url, payload, headers: headers, recursionCounter: ++recursionCounter);
              }
              await rawDelete(url, headers: headers, recursionCounter: ++recursionCounter);
              break;
          }
        }
      }
    }
    throw UnauthorizedUserException();
  }

}