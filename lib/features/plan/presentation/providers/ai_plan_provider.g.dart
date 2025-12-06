// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_plan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiPlanServiceHash() => r'f004b9bbedf0c1624f16ceb2686480637bc0fa49';

/// Provider for AI Plan Service
/// Uses AiServiceFactory to create the appropriate service based on AI_PROVIDER env var
///
/// Copied from [aiPlanService].
@ProviderFor(aiPlanService)
final aiPlanServiceProvider = AutoDisposeProvider<AiPlanService>.internal(
  aiPlanService,
  name: r'aiPlanServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiPlanServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiPlanServiceRef = AutoDisposeProviderRef<AiPlanService>;
String _$aiPlanNotifierHash() => r'c8ce3efc45168f00fa07496d1a68136534267fa4';

/// Notifier for AI plan generation
///
/// Copied from [AiPlanNotifier].
@ProviderFor(AiPlanNotifier)
final aiPlanNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      AiPlanNotifier,
      List<StudentPlan>?
    >.internal(
      AiPlanNotifier.new,
      name: r'aiPlanNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiPlanNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AiPlanNotifier = AutoDisposeAsyncNotifier<List<StudentPlan>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
