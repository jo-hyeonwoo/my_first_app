import '../../domain/entities/user.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/exceptions/auth_exception.dart';

class MockAuthRepository implements AuthRepository {
  // Mock credentials
  static final _mockUsers = [
    User(
      id: 'user-student-1',
      email: 'student@test.com',
      name: 'Kim Student',
      role: UserRole.student,
      tenantId: 'tenant-1',
    ),
    User(
      id: 'user-consultant-1',
      email: 'teacher@test.com',
      name: 'Lee Teacher',
      role: UserRole.consultant,
      tenantId: 'tenant-1',
    ),
  ];

  static final _mockTenants = [
    const Tenant(id: 'tenant-1', name: 'Seongil Academy'),
    const Tenant(id: 'tenant-2', name: 'Megastudy Center'),
  ];

  @override
  Future<User> login(String email, String password) async {
    // simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // mock password is '1234' for all users
    if (password != '1234') {
      throw AuthException.invalidCredentials();
    }

    final user = _mockUsers.firstWhere(
      (u) => u.email == email,
      orElse: () => throw AuthException.invalidCredentials(),
    );

    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // no-op for mock
  }

  @override
  Future<List<Tenant>> getAvailableTenants() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockTenants;
  }

  @override
  Future<User?> getCurrentUser() async {
    // Mock implementation: no persistent session
    return null;
  }
}
