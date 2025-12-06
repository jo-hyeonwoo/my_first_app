// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayPlansHash() => r'fd0b579ac30158c74e4c331e094e716393839a20';

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

/// See also [todayPlans].
@ProviderFor(todayPlans)
const todayPlansProvider = TodayPlansFamily();

/// See also [todayPlans].
class TodayPlansFamily extends Family<AsyncValue<List<StudentPlan>>> {
  /// See also [todayPlans].
  const TodayPlansFamily();

  /// See also [todayPlans].
  TodayPlansProvider call(String studentId) {
    return TodayPlansProvider(studentId);
  }

  @override
  TodayPlansProvider getProviderOverride(
    covariant TodayPlansProvider provider,
  ) {
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
  String? get name => r'todayPlansProvider';
}

/// See also [todayPlans].
class TodayPlansProvider extends AutoDisposeFutureProvider<List<StudentPlan>> {
  /// See also [todayPlans].
  TodayPlansProvider(String studentId)
    : this._internal(
        (ref) => todayPlans(ref as TodayPlansRef, studentId),
        from: todayPlansProvider,
        name: r'todayPlansProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todayPlansHash,
        dependencies: TodayPlansFamily._dependencies,
        allTransitiveDependencies: TodayPlansFamily._allTransitiveDependencies,
        studentId: studentId,
      );

  TodayPlansProvider._internal(
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
    FutureOr<List<StudentPlan>> Function(TodayPlansRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TodayPlansProvider._internal(
        (ref) => create(ref as TodayPlansRef),
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
  AutoDisposeFutureProviderElement<List<StudentPlan>> createElement() {
    return _TodayPlansProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodayPlansProvider && other.studentId == studentId;
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
mixin TodayPlansRef on AutoDisposeFutureProviderRef<List<StudentPlan>> {
  /// The parameter `studentId` of this provider.
  String get studentId;
}

class _TodayPlansProviderElement
    extends AutoDisposeFutureProviderElement<List<StudentPlan>>
    with TodayPlansRef {
  _TodayPlansProviderElement(super.provider);

  @override
  String get studentId => (origin as TodayPlansProvider).studentId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
