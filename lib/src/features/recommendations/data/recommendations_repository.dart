import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:soilreport/src/constants/urls.dart';
import 'package:soilreport/src/core/caching/cache_database.dart';
import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/core/data/dio_provider.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/features/authentication/data/authorized_service.dart';
import 'package:soilreport/src/features/recommendations/domain/soil_recommendation_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendations_repository.g.dart';

class RecommendationsRepository extends AuthorizedService {
  RecommendationsRepository(
    super.secureStorage,
    super.auth,
    super.cache,
    super.dio,
  );

  Future<AiRecommendationResponse> getRecommendations({
    String? userId,
    String? deviceId,
    int? limit,
    String? fromIso,
    String? toIso,
    bool useCache = true,
  }) async {
    final query = <String, String>{
      if (userId != null && userId.isNotEmpty) 'userId': userId,
      if (deviceId != null && deviceId.isNotEmpty) 'deviceId': deviceId,
      if (limit != null) 'limit': '$limit',
      if (fromIso != null && fromIso.isNotEmpty) 'from': fromIso,
      if (toIso != null && toIso.isNotEmpty) 'to': toIso,
    };
    final querySuffix = query.isEmpty
        ? ''
        : '?${query.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&')}';
    final url = '${Urls.mainEndpoint}${Urls.aiRecommendationsPath}$querySuffix';
    final cacheKey = 'recommendations::$url';

    if (useCache) {
      final cachedRaw = await cache.rawRead(
        cacheKey,
        maxAge: const Duration(hours: 2),
      );
      if (cachedRaw != null) {
        return AiRecommendationResponse.fromJson(
          jsonDecode(cachedRaw) as Map<String, dynamic>,
        );
      }
    }

    final data = await get<Map<String, dynamic>>(
      url,
      (json) => json,
      headers: const {"content-type": "application/json"},
    );
    final response = AiRecommendationResponse.fromJson(data);
    await cache.write(cacheKey, response.toJson());
    return response;
  }
}

@Riverpod(keepAlive: true)
RecommendationsRepository recommendationsRepository(Ref ref) {
  final cache = ref.watch(cacheDatabaseProvider);
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final auth = ref.watch(authRepositoryProvider);
  return RecommendationsRepository(secureStorage, auth, cache, dio);
}
