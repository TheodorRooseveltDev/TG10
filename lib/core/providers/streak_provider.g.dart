// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allStreaksHash() => r'a7efa9dc6946ec0fdc1656608ead40c0057a7ffb';

/// See also [allStreaks].
@ProviderFor(allStreaks)
final allStreaksProvider = AutoDisposeFutureProvider<List<Streak>>.internal(
  allStreaks,
  name: r'allStreaksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allStreaksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllStreaksRef = AutoDisposeFutureProviderRef<List<Streak>>;
String _$streakByDateHash() => r'dc3d958a55ba3ca8718c0393184efa44307a6138';

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

/// See also [streakByDate].
@ProviderFor(streakByDate)
const streakByDateProvider = StreakByDateFamily();

/// See also [streakByDate].
class StreakByDateFamily extends Family<AsyncValue<Streak?>> {
  /// See also [streakByDate].
  const StreakByDateFamily();

  /// See also [streakByDate].
  StreakByDateProvider call(DateTime date) {
    return StreakByDateProvider(date);
  }

  @override
  StreakByDateProvider getProviderOverride(
    covariant StreakByDateProvider provider,
  ) {
    return call(provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'streakByDateProvider';
}

/// See also [streakByDate].
class StreakByDateProvider extends AutoDisposeFutureProvider<Streak?> {
  /// See also [streakByDate].
  StreakByDateProvider(DateTime date)
    : this._internal(
        (ref) => streakByDate(ref as StreakByDateRef, date),
        from: streakByDateProvider,
        name: r'streakByDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$streakByDateHash,
        dependencies: StreakByDateFamily._dependencies,
        allTransitiveDependencies:
            StreakByDateFamily._allTransitiveDependencies,
        date: date,
      );

  StreakByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<Streak?> Function(StreakByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StreakByDateProvider._internal(
        (ref) => create(ref as StreakByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Streak?> createElement() {
    return _StreakByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StreakByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StreakByDateRef on AutoDisposeFutureProviderRef<Streak?> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _StreakByDateProviderElement
    extends AutoDisposeFutureProviderElement<Streak?>
    with StreakByDateRef {
  _StreakByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as StreakByDateProvider).date;
}

String _$currentStreakHash() => r'f72a8e992660d269b93e9438a80263b1977d0b9c';

/// See also [CurrentStreak].
@ProviderFor(CurrentStreak)
final currentStreakProvider =
    AutoDisposeAsyncNotifierProvider<CurrentStreak, int>.internal(
      CurrentStreak.new,
      name: r'currentStreakProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentStreakHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentStreak = AutoDisposeAsyncNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
