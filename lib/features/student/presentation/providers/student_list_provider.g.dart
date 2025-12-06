// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$studentRepositoryHash() => r'a6d3d36fe739f3481528ffb445169846bd4a51b3';

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
String _$managedStudentsHash() => r'43e2295af89dc941a10bd7304e21da60a835fde0';

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
