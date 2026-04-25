import 'package:soilreport/src/core/caching/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateProvider<AsyncValue<Locale?>>((ref) {
  return const AsyncValue.data(Locale('en'));
});

final localizationRepositoryProvider = Provider<LocalizationRepository>((ref) {
  return LocalizationRepository(ref);
});

class LocalizationRepository {
  final Ref _ref;
  LocalizationRepository(this._ref);

  Future<void> setLocale({required String localeCode}) async {
    _ref.read(localeProvider.notifier).state = AsyncValue.data(
      Locale(localeCode),
    );
    try {
      await _ref
          .read(secureStorageProvider)
          .writeSensitiveData('locale', localeCode);
    } catch (_) {}
  }

  Future<void> loadSavedLocale() async {
    try {
      final saved = await _ref
          .read(secureStorageProvider)
          .readSensitiveData('locale');
      if (saved != null && saved.isNotEmpty) {
        _ref.read(localeProvider.notifier).state = AsyncValue.data(
          Locale(saved),
        );
      }
    } catch (_) {}
  }
}
