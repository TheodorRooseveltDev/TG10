// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allQuestionsHash() => r'9d55d074a7756b3ec5b594356932c59a11a99373';

/// See also [allQuestions].
@ProviderFor(allQuestions)
final allQuestionsProvider = AutoDisposeFutureProvider<List<Question>>.internal(
  allQuestions,
  name: r'allQuestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allQuestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllQuestionsRef = AutoDisposeFutureProviderRef<List<Question>>;
String _$questionsByCategoryHash() =>
    r'830b4a8312c7099b3f3403934ff0193b45fbe99a';

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

/// See also [questionsByCategory].
@ProviderFor(questionsByCategory)
const questionsByCategoryProvider = QuestionsByCategoryFamily();

/// See also [questionsByCategory].
class QuestionsByCategoryFamily extends Family<AsyncValue<List<Question>>> {
  /// See also [questionsByCategory].
  const QuestionsByCategoryFamily();

  /// See also [questionsByCategory].
  QuestionsByCategoryProvider call(String category) {
    return QuestionsByCategoryProvider(category);
  }

  @override
  QuestionsByCategoryProvider getProviderOverride(
    covariant QuestionsByCategoryProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'questionsByCategoryProvider';
}

/// See also [questionsByCategory].
class QuestionsByCategoryProvider
    extends AutoDisposeFutureProvider<List<Question>> {
  /// See also [questionsByCategory].
  QuestionsByCategoryProvider(String category)
    : this._internal(
        (ref) => questionsByCategory(ref as QuestionsByCategoryRef, category),
        from: questionsByCategoryProvider,
        name: r'questionsByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$questionsByCategoryHash,
        dependencies: QuestionsByCategoryFamily._dependencies,
        allTransitiveDependencies:
            QuestionsByCategoryFamily._allTransitiveDependencies,
        category: category,
      );

  QuestionsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<Question>> Function(QuestionsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuestionsByCategoryProvider._internal(
        (ref) => create(ref as QuestionsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Question>> createElement() {
    return _QuestionsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuestionsByCategoryRef on AutoDisposeFutureProviderRef<List<Question>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _QuestionsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Question>>
    with QuestionsByCategoryRef {
  _QuestionsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as QuestionsByCategoryProvider).category;
}

String _$questionsByDifficultyHash() =>
    r'd5222847eae4ac0dae857ec4878e2a79252f3e4f';

/// See also [questionsByDifficulty].
@ProviderFor(questionsByDifficulty)
const questionsByDifficultyProvider = QuestionsByDifficultyFamily();

/// See also [questionsByDifficulty].
class QuestionsByDifficultyFamily extends Family<AsyncValue<List<Question>>> {
  /// See also [questionsByDifficulty].
  const QuestionsByDifficultyFamily();

  /// See also [questionsByDifficulty].
  QuestionsByDifficultyProvider call(String difficulty) {
    return QuestionsByDifficultyProvider(difficulty);
  }

  @override
  QuestionsByDifficultyProvider getProviderOverride(
    covariant QuestionsByDifficultyProvider provider,
  ) {
    return call(provider.difficulty);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'questionsByDifficultyProvider';
}

/// See also [questionsByDifficulty].
class QuestionsByDifficultyProvider
    extends AutoDisposeFutureProvider<List<Question>> {
  /// See also [questionsByDifficulty].
  QuestionsByDifficultyProvider(String difficulty)
    : this._internal(
        (ref) =>
            questionsByDifficulty(ref as QuestionsByDifficultyRef, difficulty),
        from: questionsByDifficultyProvider,
        name: r'questionsByDifficultyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$questionsByDifficultyHash,
        dependencies: QuestionsByDifficultyFamily._dependencies,
        allTransitiveDependencies:
            QuestionsByDifficultyFamily._allTransitiveDependencies,
        difficulty: difficulty,
      );

  QuestionsByDifficultyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.difficulty,
  }) : super.internal();

  final String difficulty;

  @override
  Override overrideWith(
    FutureOr<List<Question>> Function(QuestionsByDifficultyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuestionsByDifficultyProvider._internal(
        (ref) => create(ref as QuestionsByDifficultyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        difficulty: difficulty,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Question>> createElement() {
    return _QuestionsByDifficultyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionsByDifficultyProvider &&
        other.difficulty == difficulty;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, difficulty.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuestionsByDifficultyRef on AutoDisposeFutureProviderRef<List<Question>> {
  /// The parameter `difficulty` of this provider.
  String get difficulty;
}

class _QuestionsByDifficultyProviderElement
    extends AutoDisposeFutureProviderElement<List<Question>>
    with QuestionsByDifficultyRef {
  _QuestionsByDifficultyProviderElement(super.provider);

  @override
  String get difficulty => (origin as QuestionsByDifficultyProvider).difficulty;
}

String _$questionByIdHash() => r'81b6bea115fcfa332f909a03216d8eaee4f18644';

/// See also [questionById].
@ProviderFor(questionById)
const questionByIdProvider = QuestionByIdFamily();

/// See also [questionById].
class QuestionByIdFamily extends Family<AsyncValue<Question?>> {
  /// See also [questionById].
  const QuestionByIdFamily();

  /// See also [questionById].
  QuestionByIdProvider call(int id) {
    return QuestionByIdProvider(id);
  }

  @override
  QuestionByIdProvider getProviderOverride(
    covariant QuestionByIdProvider provider,
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
  String? get name => r'questionByIdProvider';
}

/// See also [questionById].
class QuestionByIdProvider extends AutoDisposeFutureProvider<Question?> {
  /// See also [questionById].
  QuestionByIdProvider(int id)
    : this._internal(
        (ref) => questionById(ref as QuestionByIdRef, id),
        from: questionByIdProvider,
        name: r'questionByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$questionByIdHash,
        dependencies: QuestionByIdFamily._dependencies,
        allTransitiveDependencies:
            QuestionByIdFamily._allTransitiveDependencies,
        id: id,
      );

  QuestionByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<Question?> Function(QuestionByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuestionByIdProvider._internal(
        (ref) => create(ref as QuestionByIdRef),
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
  AutoDisposeFutureProviderElement<Question?> createElement() {
    return _QuestionByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionByIdProvider && other.id == id;
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
mixin QuestionByIdRef on AutoDisposeFutureProviderRef<Question?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _QuestionByIdProviderElement
    extends AutoDisposeFutureProviderElement<Question?>
    with QuestionByIdRef {
  _QuestionByIdProviderElement(super.provider);

  @override
  int get id => (origin as QuestionByIdProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
