import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../plan/presentation/providers/plan_providers.dart';
import '../../../plan/presentation/providers/ai_plan_provider.dart';
import '../../../plan/presentation/widgets/plan_card.dart';
import '../../../score/domain/entities/score.dart';
import '../../../score/presentation/providers/score_providers.dart';

class StudentDetailScreen extends ConsumerWidget {
  final String studentId;
  final String studentName;

  const StudentDetailScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  String _koreanDateHeader(DateTime date) {
    final df = DateFormat('M월 d일 (E)', 'ko_KR');
    return '${df.format(date)} - 오늘의 학습';
  }

  Color _subjectColor(String subject) {
    switch (subject) {
      case '국어':
        return Colors.deepOrange;
      case '영어':
        return Colors.teal;
      case '수학':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$studentName 학생'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '플랜'),
              Tab(text: '성적'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Plans Tab
            _buildPlansTab(context, ref),
            // Scores Tab
            _buildScoresTab(context, ref),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);
            return AnimatedBuilder(
              animation: tabController,
              builder: (context, child) {
                // Show FAB only when Plans tab is active
                if (tabController.index != 0) {
                  return const SizedBox.shrink();
                }
                
                final date = ref.read(currentDateProvider);
                return FloatingActionButton.extended(
                  onPressed: () async {
                    // Clear previous AI generation state
                    ref.read(aiPlanNotifierProvider.notifier).clear();
                    
                    final result = await context.push(
                      '/plan-generation/$studentId?date=${date.toIso8601String()}',
                    );
                    
                    // If plans were saved, refresh the plan list
                    if (result == true) {
                      ref.invalidate(todayPlansProvider(studentId));
                    }
                  },
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('✨ AI 플랜 생성'),
                  tooltip: '$studentName 학생을 위한 AI 플랜 생성',
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlansTab(BuildContext context, WidgetRef ref) {
    final date = ref.watch(currentDateProvider);
    final todayPlansAsync = ref.watch(todayPlansProvider(studentId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            automaticallyImplyLeading: false,
            elevation: 0,
            expandedHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
              title: Text(_koreanDateHeader(date)),
            ),
          ),

          todayPlansAsync.when(
            data: (plans) {
              if (plans.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 64,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '오늘의 플랜이 없습니다.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: plans.length,
                  (context, index) {
                    final plan = plans[index];
                    return PlanCard(
                      plan: plan,
                      onToggleCompleted: (v) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${plan.titleOverride} 상태 변경 (mock)'),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (e, st) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('오류 발생: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoresTab(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(scoreListProvider(studentId));

    return scoresAsync.when(
      data: (scores) {
        if (scores.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assessment,
                  size: 64,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  '성적 데이터가 없습니다.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }

        // Group scores by subject for chart
        final koreanScores = scores.where((s) => s.subject == '국어').toList();
        final englishScores = scores.where((s) => s.subject == '영어').toList();
        final mathScores = scores.where((s) => s.subject == '수학').toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              // LineChart
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 300,
                      child: _buildLineChart(koreanScores, englishScores, mathScores),
                    ),
                  ),
                ),
              ),

              // Legend
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _LegendItem(color: _subjectColor('국어'), label: '국어'),
                    _LegendItem(color: _subjectColor('영어'), label: '영어'),
                    _LegendItem(color: _subjectColor('수학'), label: '수학'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Score List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '시험별 성적',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...scores.map((score) {
                      final dateStr = DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(score.date);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    score.examName,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$dateStr • ${score.subject}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${score.rawScore.toStringAsFixed(1)}점',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${score.grade}등급',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('오류 발생: $e')),
    );
  }

  Widget _buildLineChart(
    List<Score> koreanScores,
    List<Score> englishScores,
    List<Score> mathScores,
  ) {
    final allScores = [...koreanScores, ...englishScores, ...mathScores];
    allScores.sort((a, b) => a.date.compareTo(b.date));

    final spotGroups = <String, List<FlSpot>>{};

    for (int i = 0; i < allScores.length; i++) {
      final score = allScores[i];
      final key = score.subject;

      if (!spotGroups.containsKey(key)) {
        spotGroups[key] = [];
      }

      spotGroups[key]!.add(FlSpot(i.toDouble(), score.rawScore.toDouble()));
    }

    final koreanSpots = spotGroups['국어'] ?? [];
    final englishSpots = spotGroups['영어'] ?? [];
    final mathSpots = spotGroups['수학'] ?? [];

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: koreanSpots,
            isCurved: true,
            color: _subjectColor('국어'),
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: englishSpots,
            isCurved: true,
            color: _subjectColor('영어'),
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: mathSpots,
            isCurved: true,
            color: _subjectColor('수학'),
            barWidth: 2,
            belowBarData: BarAreaData(show: false),
            dotData: const FlDotData(show: true),
          ),
        ],
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
