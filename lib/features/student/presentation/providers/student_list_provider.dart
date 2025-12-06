import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/real_student_repository.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'student_list_provider.g.dart';

@riverpod
StudentRepository studentRepository(StudentRepositoryRef ref) {
  return RealStudentRepository();
}

@riverpod
Future<List<Student>> managedStudents(ManagedStudentsRef ref) async {
  final authState = ref.watch(authNotifierProvider);
  
  final user = authState.maybeWhen(
    data: (user) => user,
    orElse: () => null,
  );

  if (user == null) {
    return [];
  }

  final studentRepo = ref.watch(studentRepositoryProvider);
  return studentRepo.getManagedStudents(user.id);
}
