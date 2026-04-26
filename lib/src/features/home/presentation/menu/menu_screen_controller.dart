import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final versionAndLanguageProvider = FutureProvider.autoDispose<(String,bool)>
  ((ref) async {
  final info = await PackageInfo.fromPlatform();

  final isRealScope = ref.watch(secureStorageProvider).hasRefreshToken;
  return ("v${info.version}", isRealScope);
});
