import 'package:soilreport/src/app.dart';
import 'package:soilreport/src/core/services/app_initializer.dart';
import 'package:soilreport/src/core/services/connectivity_service.dart';
import 'package:soilreport/src/exceptions/async_error_logger.dart';
import 'package:soilreport/src/exceptions/error_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  // * Create ProviderContainer with any required overrides
  final container = ProviderContainer(
    observers: [AsyncErrorLogger()],
  );
  
  final errorLogger = container.read(errorLoggerProvider);
  
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers(errorLogger);
  
  // * Initialize all repositories/services using centralized initializer
  // This checks connectivity before attempting network operations
  try{
    await container.read(connectivityServiceInitializerProvider.future);
    await container.read(appInitializerProvider.future);
  }catch (ex) {
    debugPrint(ex.toString());
  }
  
  // * Entry point of the app
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(), 
  ));
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    debugPrint('Widget build error: ${details.exception}');
    return const SizedBox.shrink(); // Minimal fallback to avoid crash
  };
}
