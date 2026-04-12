// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_initializer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appInitializerHash() => r'5611e7168e750739881ce94ec3494edf21afb62e';

/// Centralized app initializer that checks connectivity before attempting network operations
///
/// This initializer ensures all critical providers are read into the container.
/// When you call `ref.read()` inside this provider, those providers are created
/// and stored in the ProviderContainer, making them available throughout the app.
///
/// Copied from [appInitializer].
@ProviderFor(appInitializer)
final appInitializerProvider = FutureProvider<void>.internal(
  appInitializer,
  name: r'appInitializerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appInitializerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppInitializerRef = FutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
