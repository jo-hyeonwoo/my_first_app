// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scoreListHash() => r'3d8d7fb4a78549cab63a700e8825c5000b92057f';

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

/// See also [scoreList].
@ProviderFor(scoreList)
const scoreListProvider = ScoreListFamily();

/// See also [scoreList].
class ScoreListFamily extends Family<AsyncValue<List<Score>>> {
  /// See also [scoreList].
  const ScoreListFamily();

  /// See also [scoreList].
  ScoreListProvider call(String studentId) {
    return ScoreListProvider(studentId);
  }

  @override
  ScoreListProvider getProviderOverride(covariant ScoreListProvider provider) {
    return call(provider.studentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'scoreListProvider';
}

/// See also [scoreList].
class ScoreListProvider extends AutoDisposeFutureProvider<List<Score>> {
  /// See also [scoreList].
  ScoreListProvider(String studentId)
    : this._internal(
        (ref) => scoreList(ref as ScoreListRef, studentId),
        from: scoreListProvider,
        name: r'scoreListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$scoreListHash,
        dependencies: ScoreListFamily._dependencies,
        allTransitiveDependencies: ScoreListFamily._allTransitiveDependencies,
        studentId: studentId,
      );

  ScoreListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.studentId,
  }) : super.internal();

  final String studentId;

  @override
  Override overrideWith(
    FutureOr<List<Score>> Function(ScoreListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScoreListProvider._internal(
        (ref) => create(ref as ScoreListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        studentId: studentId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Score>> createElement() {
    return _ScoreListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScoreListProvider && other.studentId == studentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, studentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScoreListRef on AutoDisposeFutureProviderRef<List<Score>> {
  /// The parameter `studentId` of this provider.
  String get studentId;
}

class _ScoreListProviderElement
    extends AutoDisposeFutureProviderElement<List<Score>>
    with ScoreListRef {
  _ScoreListProviderElement(super.provider);

  @override
  String get studentId => (origin as ScoreListProvider).studentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
