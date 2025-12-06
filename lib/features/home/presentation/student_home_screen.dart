import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import '../../plan/presentation/providers/plan_providers.dart';
import '../../plan/presentation/widgets/plan_card.dart';
import '../../plan/presentation/providers/ai_plan_provider.dart';

class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({super.key});

  String _koreanDateHeader(DateTime date) {
    final df = DateFormat('M월 d일 (E)', 'ko_KR');
    return '${df.format(date)} - 오늘의 학습';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final date = ref.watch(currentDateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Not authenticated')),
          );
        }

        final todayPlansAsync = ref.watch(todayPlansProvider(user.id));

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
                  title: Text(_koreanDateHeader(date)),
                ),
              ),

              // content
              todayPlansAsync.when(
                data: (plans) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: plans.length,
                    (context, index) {
                      final plan = plans[index];
                      return PlanCard(
                        plan: plan,
                        onToggleCompleted: (v) {
                          // For mock/demo: show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${plan.titleOverride} 상태 변경 (mock)')),
                          );
                        },
                      );
                    },
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                    child: SizedBox(height: 160, child: Center(child: CircularProgressIndicator()))),
                error: (e, st) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('오류 발생: $e')),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              // Clear previous AI generation state
              ref.read(aiPlanNotifierProvider.notifier).clear();
              
              final result = await context.push(
                '/plan-generation/${user.id}?date=${date.toIso8601String()}',
              );
              
              // If plans were saved, refresh the plan list
              if (result == true) {
                ref.invalidate(todayPlansProvider(user.id));
              }
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('✨ AI 플랜 생성'),
            tooltip: 'AI로 학습 플랜 생성하기',
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}
