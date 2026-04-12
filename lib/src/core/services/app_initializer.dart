import 'package:soilreport/src/core/services/connectivity_service.dart';
import 'package:soilreport/src/core/services/connectivity_service.dart';
import 'package:soilreport/src/exceptions/app_exception.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:soilreport/src/core/services/firebase_service.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_initializer.g.dart';

/// Centralized app initializer that checks connectivity before attempting network operations
/// 
/// This initializer ensures all critical providers are read into the container.
/// When you call `ref.read()` inside this provider, those providers are created
/// and stored in the ProviderContainer, making them available throughout the app.
@Riverpod(keepAlive: true)
Future<void> appInitializer(Ref ref) async {
  // Check connectivity first using connectivity_plus
  try{
    final hasNetwork = ref.read(connectivityServiceProvider).connectivityStatus;
    if (hasNetwork != ConnectivityStatus.hasServerConnection) {
      ref.read(authRepositoryProvider);
      ref.read(firebaseServiceProvider);
      return;
    }
    await ref.read(authInitializerProvider.future);
    ref.read(authStateChangesProvider);
    }  catch (e) {
    return;
  }
}
