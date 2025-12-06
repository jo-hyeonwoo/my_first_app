import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import 'providers/score_providers.dart';

class ScoreScreen extends ConsumerWidget {
  const ScoreScreen({super.key});

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
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Not authenticated')),
          );
        }

        final scoresAsync = ref.watch(scoreListProvider(user.id));

        return Scaffold(
          appBar: AppBar(title: const Text('성적 현황')),
          body: scoresAsync.when(
            data: (scores) {
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
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    // Show exam names or dates
                                    if (scores.isEmpty || value.toInt() >= scores.length) {
                                      return const Text('');
                                    }
                                    final score = scores[value.toInt()];
                                    final df = DateFormat('M/d');
                                    return Text(df.format(score.date));
                                  },
                                  reservedSize: 40,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text('${value.toInt()}');
                                  },
                                  reservedSize: 40,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              // Korean line
                              LineChartBarData(
                                spots: List.generate(
                                  koreanScores.length,
                                  (i) => FlSpot(
                                    scores.indexOf(koreanScores[i]).toDouble(),
                                    koreanScores[i].rawScore.toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: _subjectColor('국어'),
                                barWidth: 2,
                                dotData: const FlDotData(show: true),
                              ),
                              // English line
                              LineChartBarData(
                                spots: List.generate(
                                  englishScores.length,
                                  (i) => FlSpot(
                                    scores.indexOf(englishScores[i]).toDouble(),
                                    englishScores[i].rawScore.toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: _subjectColor('영어'),
                                barWidth: 2,
                                dotData: const FlDotData(show: true),
                              ),
                              // Math line
                              LineChartBarData(
                                spots: List.generate(
                                  mathScores.length,
                                  (i) => FlSpot(
                                    scores.indexOf(mathScores[i]).toDouble(),
                                    mathScores[i].rawScore.toDouble(),
                                  ),
                                ),
                                isCurved: true,
                                color: _subjectColor('수학'),
                                barWidth: 2,
                                dotData: const FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Legend
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LegendItem(color: _subjectColor('국어'), label: '국어'),
                      const SizedBox(width: 16),
                      _LegendItem(color: _subjectColor('영어'), label: '영어'),
                      const SizedBox(width: 16),
                      _LegendItem(color: _subjectColor('수학'), label: '수학'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Score list
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('성적 기록',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: scores.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final score = scores[index];
                          return ListTile(
                            title: Text('${score.examName} - ${score.subject}'),
                            subtitle: Text(
                              '원점수: ${score.rawScore}, 표준점수: ${score.standardScore ?? '-'}, 등급: ${score.grade ?? '-'}',
                            ),
                            trailing: Text(
                              DateFormat('yyyy.MM.dd').format(score.date),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('오류 발생: $e')),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('성적 현황')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $err')),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
