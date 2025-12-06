import '../entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getManagedStudents(String consultantId);
}
