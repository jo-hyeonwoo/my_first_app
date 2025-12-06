import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

class MockStudentRepository implements StudentRepository {
  // Mock data: students managed by different consultants
  static final _mockStudents = {
    'user-consultant-1': [
      Student(
        id: 'student-1',
        name: '김철수',
        schoolName: '서울고등학교',
        grade: 2,
        status: StudentStatus.active,
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
        tenantId: 'tenant-1',
      ),
      Student(
        id: 'student-2',
        name: '이영희',
        schoolName: '서울고등학교',
        grade: 3,
        status: StudentStatus.active,
        lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
        tenantId: 'tenant-1',
      ),
      Student(
        id: 'student-3',
        name: '박민준',
        schoolName: '성남고등학교',
        grade: 1,
        status: StudentStatus.active,
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 5)),
        tenantId: 'tenant-1',
      ),
      Student(
        id: 'student-4',
        name: '최지은',
        schoolName: '서울고등학교',
        grade: 2,
        status: StudentStatus.inactive,
        lastLoginAt: DateTime.now().subtract(const Duration(days: 7)),
        tenantId: 'tenant-1',
      ),
      Student(
        id: 'student-5',
        name: '정준호',
        schoolName: '중앙고등학교',
        grade: 3,
        status: StudentStatus.active,
        lastLoginAt: DateTime.now().subtract(const Duration(minutes: 30)),
        tenantId: 'tenant-1',
      ),
    ],
  };

  @override
  Future<List<Student>> getManagedStudents(String consultantId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    final students = _mockStudents[consultantId] ?? [];
    // Sort by status (active first) and then by lastLoginAt (most recent first)
    students.sort((a, b) {
      if (a.status != b.status) {
        return a.status == StudentStatus.active ? -1 : 1;
      }
      return b.lastLoginAt.compareTo(a.lastLoginAt);
    });
    
    return students;
  }
}
