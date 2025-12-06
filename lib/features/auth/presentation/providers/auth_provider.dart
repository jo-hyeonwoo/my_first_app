import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/real_auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return RealAuthRepository();
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    // On app start, try to restore session automatically
    final authRepo = ref.read(authRepositoryProvider);
    final user = await authRepo.getCurrentUser();
    return user;
  }

  /// Restores user session from Supabase if a valid session exists
  Future<void> restoreSession() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.getCurrentUser();
      return user;
    });
    
    // If restoration failed, ensure we're in unauthenticated state
    if (state.hasError || state.valueOrNull == null) {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final user = await authRepo.login(email, password);
      return user;
    });
  }

  Future<void> logout() async {
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.logout();
    } catch (e) {
      // Even if logout fails, clear local state
    } finally {
      state = const AsyncValue.data(null);
    }
  }
}

@riverpod
Future<List<Tenant>> availableTenants(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.getAvailableTenants();
}
