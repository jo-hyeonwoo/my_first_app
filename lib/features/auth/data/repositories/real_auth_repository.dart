import 'package:supabase_flutter/supabase_flutter.dart' hide User, AuthException;
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../domain/entities/user.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/exceptions/auth_exception.dart';

class RealAuthRepository implements AuthRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<User> login(String email, String password) async {
    try {
      // Sign in with Supabase Auth
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final authUser = response.user;
      if (authUser == null) {
        throw AuthException.invalidCredentials();
      }

      // Query user details from public.users table
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', authUser.id)
          .single();

      // Map to User entity
      final user = User(
        id: authUser.id,
        email: authUser.email ?? email,
        name: userData['name'] ?? 'Unknown',
        role: _parseRole(userData['role'] ?? 'student'),
        tenantId: userData['tenant_id'] ?? 'default',
      );

      return user;
    } on AuthException {
      rethrow;
    } on AuthApiException catch (e, stackTrace) {
      print('AuthApiException during login: ${e.statusCode} - ${e.message}');
      if (e.statusCode == '401' || e.message.contains('Invalid credentials')) {
        throw AuthException.invalidCredentials();
      }
      // Send network errors to Sentry
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'context': 'Auth Login - AuthApiException',
          'email': email,
          'statusCode': e.statusCode ?? 'unknown',
          'message': e.message,
        }),
      );
      throw AuthException.networkError();
    } catch (e, stackTrace) {
      // Log detailed error information
      print('Error during login: $e');
      print('Error type: ${e.runtimeType}');
      print('Stack trace: $stackTrace');
      
      // Send unknown errors to Sentry
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'context': 'Auth Login - Unknown Error',
          'email': email,
          'errorType': e.runtimeType.toString(),
          'errorMessage': e.toString(),
        }),
      );
      throw AuthException.unknown(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e, stackTrace) {
      // Send logout errors to Sentry
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'context': 'Auth Logout',
        }),
      );
      throw AuthException.unknown(e.toString());
    }
  }

  @override
  Future<List<Tenant>> getAvailableTenants() async {
    try {
      final tenants = await _supabase
          .from('tenants')
          .select()
          .order('name');

      return (tenants as List)
          .map((t) => Tenant(
                id: t['id'],
                name: t['name'],
              ))
          .toList();
    } catch (e, stackTrace) {
      // Send tenant fetch errors to Sentry
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'context': 'Get Available Tenants',
        }),
      );
      throw AuthException.unknown(e.toString());
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // Check if there's a valid session
      final session = _supabase.auth.currentSession;
      if (session == null) {
        return null;
      }

      final authUser = session.user;

      // Query user details from public.users table
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', authUser.id)
          .single();

      // Map to User entity
      final user = User(
        id: authUser.id,
        email: authUser.email ?? '',
        name: userData['name'] ?? 'Unknown',
        role: _parseRole(userData['role'] ?? 'student'),
        tenantId: userData['tenant_id'] ?? 'default',
      );

      return user;
    } catch (e) {
      // If any error occurs (invalid session, network error, etc.), return null
      return null;
    }
  }

  UserRole _parseRole(String roleString) {
    return UserRole.values.firstWhere(
      (role) => role.name == roleString,
      orElse: () => UserRole.student,
    );
  }
}
