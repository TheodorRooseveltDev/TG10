// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$incorrectAnswersHash() => r'e14784ddc76cfac04dc593cb939a679daec40a4a';

/// See also [incorrectAnswers].
@ProviderFor(incorrectAnswers)
final incorrectAnswersProvider =
    AutoDisposeFutureProvider<List<UserProgress>>.internal(
      incorrectAnswers,
      name: r'incorrectAnswersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$incorrectAnswersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IncorrectAnswersRef = AutoDisposeFutureProviderRef<List<UserProgress>>;
String _$progressByQuestionHash() =>
    r'469b9d982f5b9a89ee109f01b8f23d3a69ea89bf';

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

/// See also [progressByQuestion].
@ProviderFor(progressByQuestion)
const progressByQuestionProvider = ProgressByQuestionFamily();

/// See also [progressByQuestion].
class ProgressByQuestionFamily extends Family<AsyncValue<List<UserProgress>>> {
  /// See also [progressByQuestion].
  const ProgressByQuestionFamily();

  /// See also [progressByQuestion].
  ProgressByQuestionProvider call(int questionId) {
    return ProgressByQuestionProvider(questionId);
  }

  @override
  ProgressByQuestionProvider getProviderOverride(
    covariant ProgressByQuestionProvider provider,
  ) {
    return call(provider.questionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'progressByQuestionProvider';
}

/// See also [progressByQuestion].
class ProgressByQuestionProvider
    extends AutoDisposeFutureProvider<List<UserProgress>> {
  /// See also [progressByQuestion].
  ProgressByQuestionProvider(int questionId)
    : this._internal(
        (ref) => progressByQuestion(ref as ProgressByQuestionRef, questionId),
        from: progressByQuestionProvider,
        name: r'progressByQuestionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$progressByQuestionHash,
        dependencies: ProgressByQuestionFamily._dependencies,
        allTransitiveDependencies:
            ProgressByQuestionFamily._allTransitiveDependencies,
        questionId: questionId,
      );

  ProgressByQuestionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.questionId,
  }) : super.internal();

  final int questionId;

  @override
  Override overrideWith(
    FutureOr<List<UserProgress>> Function(ProgressByQuestionRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProgressByQuestionProvider._internal(
        (ref) => create(ref as ProgressByQuestionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        questionId: questionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserProgress>> createElement() {
    return _ProgressByQuestionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProgressByQuestionProvider &&
        other.questionId == questionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, questionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProgressByQuestionRef
    on AutoDisposeFutureProviderRef<List<UserProgress>> {
  /// The parameter `questionId` of this provider.
  int get questionId;
}

class _ProgressByQuestionProviderElement
    extends AutoDisposeFutureProviderElement<List<UserProgress>>
    with ProgressByQuestionRef {
  _ProgressByQuestionProviderElement(super.provider);

  @override
  int get questionId => (origin as ProgressByQuestionProvider).questionId;
}

String _$userProgressNotifierHash() =>
    r'851616be16f2db614e8888bc67676028d966d65a';

/// See also [UserProgressNotifier].
@ProviderFor(UserProgressNotifier)
final userProgressNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      UserProgressNotifier,
      List<UserProgress>
    >.internal(
      UserProgressNotifier.new,
      name: r'userProgressNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userProgressNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserProgressNotifier = AutoDisposeAsyncNotifier<List<UserProgress>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
