// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryAccuracyHash() => r'35bc54dc6fd8216bfbe4af3c744058e5e33a16ea';

/// See also [categoryAccuracy].
@ProviderFor(categoryAccuracy)
final categoryAccuracyProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
      categoryAccuracy,
      name: r'categoryAccuracyProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryAccuracyHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryAccuracyRef = AutoDisposeFutureProviderRef<Map<String, double>>;
String _$overallAccuracyHash() => r'bca11c4e178bfb7fe8c2cd2374ce164940b44614';

/// See also [overallAccuracy].
@ProviderFor(overallAccuracy)
final overallAccuracyProvider = AutoDisposeFutureProvider<double>.internal(
  overallAccuracy,
  name: r'overallAccuracyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$overallAccuracyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OverallAccuracyRef = AutoDisposeFutureProviderRef<double>;
String _$statisticsHash() => r'9cd072ad6f51e57f7c29266b1e85cb05afd05c00';

/// See also [Statistics].
@ProviderFor(Statistics)
final statisticsProvider =
    AutoDisposeAsyncNotifierProvider<Statistics, AppStatistics>.internal(
      Statistics.new,
      name: r'statisticsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$statisticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Statistics = AutoDisposeAsyncNotifier<AppStatistics>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
