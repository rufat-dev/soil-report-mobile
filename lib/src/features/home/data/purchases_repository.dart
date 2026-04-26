import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:soilreport/src/constants/urls.dart';
import 'package:soilreport/src/core/caching/cache_database.dart';
import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:soilreport/src/core/data/dio_provider.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/features/authentication/data/authorized_service.dart';
import 'package:soilreport/src/features/home/domain/purchase_record_model.dart';

class PurchasesRepository extends AuthorizedService {
  PurchasesRepository(
    super.secureStorage,
    super.auth,
    super.cache,
    super.dio,
  );

  Future<List<PurchaseRecordModel>> listPurchases({
    int limit = 50,
    int offset = 0,
    String? deviceId,
  }) async {
    final query = <String, String>{
      'limit': '$limit',
      'offset': '$offset',
      if (deviceId != null && deviceId.trim().isNotEmpty) 'deviceId': deviceId,
    };
    final querySuffix = query.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    final url = '${Urls.mainEndpoint}${Urls.purchasesPath}?$querySuffix';
    final data = await rawGetDynamic(
      url,
      headers: const {"content-type": "application/json"},
    );
    if (data is! List) {
      return const [];
    }
    return data
        .whereType<Map>()
        .map((e) => PurchaseRecordModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

final purchasesRepositoryProvider = Provider<PurchasesRepository>((ref) {
  final cache = ref.watch(cacheDatabaseProvider);
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final auth = ref.watch(authRepositoryProvider);
  return PurchasesRepository(secureStorage, auth, cache, dio);
});
