import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/student_plan.dart';
import '../../presentation/providers/ai_plan_provider.dart';
import '../../presentation/providers/plan_providers.dart';
import '../../presentation/widgets/plan_card.dart';

class PlanGenerationScreen extends ConsumerStatefulWidget {
  final String studentId;
  final DateTime? planDate;

  const PlanGenerationScreen({
    super.key,
    required this.studentId,
    this.planDate,
  });

  @override
  ConsumerState<PlanGenerationScreen> createState() =>
      _PlanGenerationScreenState();
}

class _PlanGenerationScreenState extends ConsumerState<PlanGenerationScreen> {
  final _subjectsController = TextEditingController();
  final _minutesController = TextEditingController(text: '120');
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void dispose() {
    _subjectsController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  Future<void> _generatePlans() async {
    if (!_formKey.currentState!.validate()) return;

    final subjectsText = _subjectsController.text.trim();
    if (subjectsText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('과목을 입력해주세요.')),
      );
      return;
    }

    final subjects = subjectsText.split(',').map((s) => s.trim()).toList();
    final minutes = int.tryParse(_minutesController.text) ?? 120;

    final authState = ref.read(authNotifierProvider);
    final user = authState.valueOrNull;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final planDate = widget.planDate ?? DateTime.now();
    final planDateOnly = DateTime(planDate.year, planDate.month, planDate.day);

    await ref.read(aiPlanNotifierProvider.notifier).generatePlans(
          studentId: widget.studentId,
          focusSubjects: subjects,
          availableMinutes: minutes,
          tenantId: user.tenantId,
          planDate: planDateOnly,
        );
  }

  Future<void> _savePlans() async {
    final generatedPlans = ref.read(aiPlanNotifierProvider).valueOrNull;
    if (generatedPlans == null || generatedPlans.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장할 플랜이 없습니다.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(planRepositoryProvider);
      await repo.savePlans(generatedPlans);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('플랜이 저장되었습니다!')),
        );
        context.pop(true); // Return true to indicate success
      }
    } catch (e, stackTrace) {
      // Send save errors to Sentry
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'context': 'Save Plans from UI',
          'planCount': generatedPlans.length.toString(),
          'studentId': widget.studentId,
        }),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final planDate = widget.planDate ?? DateTime.now();
    final dateText = DateFormat('yyyy년 M월 d일', 'ko_KR').format(planDate);
    final generatedPlansState = ref.watch(aiPlanNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('✨ AI 플랜 생성'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Display
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        dateText,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Subjects Input
              TextFormField(
                controller: _subjectsController,
                decoration: InputDecoration(
                  labelText: '중점 과목',
                  hintText: '예: 수학, 영어, 국어',
                  helperText: '쉼표로 구분하여 여러 과목 입력',
                  prefixIcon: const Icon(Icons.subject),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '과목을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Available Minutes Input
              TextFormField(
                controller: _minutesController,
                decoration: InputDecoration(
                  labelText: '가용 시간 (분)',
                  hintText: '120',
                  prefixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '가용 시간을 입력해주세요.';
                  }
                  final minutes = int.tryParse(value);
                  if (minutes == null || minutes <= 0) {
                    return '유효한 시간을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Generate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: generatedPlansState.isLoading ? null : _generatePlans,
                  icon: generatedPlansState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(
                    generatedPlansState.isLoading
                        ? 'AI 플랜 생성 중...'
                        : '✨ AI 플랜 생성하기',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Generated Plans Preview
              if (generatedPlansState.hasError)
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            Text(
                              '오류 발생',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          generatedPlansState.error.toString(),
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),
                ),

              if (generatedPlansState.hasValue &&
                  generatedPlansState.value != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '생성된 플랜 미리보기',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ...generatedPlansState.value!.map((plan) => PlanCard(
                          plan: plan,
                          onToggleCompleted: null, // Read-only in preview
                        )),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _savePlans,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _isSaving ? '저장 중...' : '💾 이대로 저장하기',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

