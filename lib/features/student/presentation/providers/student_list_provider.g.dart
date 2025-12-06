// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentRepositoryHash() => r'f84302a443b6060e6df9a4f3255f0558f93f010f';

/// See also [studentRepository].
@ProviderFor(studentRepository)
final studentRepositoryProvider =
    AutoDisposeProvider<StudentRepository>.internal(
      studentRepository,
      name: r'studentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$studentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StudentRepositoryRef = AutoDisposeProviderRef<StudentRepository>;
String _$managedStudentsHash() => r'29548e0cc21894476585c0032e64d5f8581424fc';

/// See also [managedStudents].
@ProviderFor(managedStudents)
final managedStudentsProvider =
    AutoDisposeFutureProvider<List<Student>>.internal(
      managedStudents,
      name: r'managedStudentsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$managedStudentsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ManagedStudentsRef = AutoDisposeFutureProviderRef<List<Student>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
