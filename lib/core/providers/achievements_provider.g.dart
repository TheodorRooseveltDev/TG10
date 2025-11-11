// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$achievementByIdHash() => r'7d68e5fea902f4d62c68854f33ad29a8b53f7e64';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [achievementById].
@ProviderFor(achievementById)
const achievementByIdProvider = AchievementByIdFamily();

/// See also [achievementById].
class AchievementByIdFamily extends Family<AsyncValue<Achievement?>> {
  /// See also [achievementById].
  const AchievementByIdFamily();

  /// See also [achievementById].
  AchievementByIdProvider call(String id) {
    return AchievementByIdProvider(id);
  }

  @override
  AchievementByIdProvider getProviderOverride(
    covariant AchievementByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'achievementByIdProvider';
}

/// See also [achievementById].
class AchievementByIdProvider extends AutoDisposeFutureProvider<Achievement?> {
  /// See also [achievementById].
  AchievementByIdProvider(String id)
    : this._internal(
        (ref) => achievementById(ref as AchievementByIdRef, id),
        from: achievementByIdProvider,
        name: r'achievementByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$achievementByIdHash,
        dependencies: AchievementByIdFamily._dependencies,
        allTransitiveDependencies:
            AchievementByIdFamily._allTransitiveDependencies,
        id: id,
      );

  AchievementByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Achievement?> Function(AchievementByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AchievementByIdProvider._internal(
        (ref) => create(ref as AchievementByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Achievement?> createElement() {
    return _AchievementByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AchievementByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AchievementByIdRef on AutoDisposeFutureProviderRef<Achievement?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _AchievementByIdProviderElement
    extends AutoDisposeFutureProviderElement<Achievement?>
    with AchievementByIdRef {
  _AchievementByIdProviderElement(super.provider);

  @override
  String get id => (origin as AchievementByIdProvider).id;
}

String _$achievementsHash() => r'bd501cf8b79b2025894e0d59b75b566b570fda13';

/// See also [Achievements].
@ProviderFor(Achievements)
final achievementsProvider =
    AutoDisposeAsyncNotifierProvider<Achievements, List<Achievement>>.internal(
      Achievements.new,
      name: r'achievementsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$achievementsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Achievements = AutoDisposeAsyncNotifier<List<Achievement>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
