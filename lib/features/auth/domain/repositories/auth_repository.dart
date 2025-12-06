import '../entities/user.dart';
import '../entities/tenant.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<List<Tenant>> getAvailableTenants();
  /// Restores user session if a valid session exists
  /// Returns User if session is valid, null otherwise
  Future<User?> getCurrentUser();
}
