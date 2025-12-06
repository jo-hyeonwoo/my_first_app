import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/student_plan.dart';
import '../../domain/services/ai_plan_service.dart';

class GeminiPlanService implements AiPlanService {
  final _uuid = const Uuid();
  static const String _modelName = 'gemini-1.5-flash';

  @override
  Future<List<StudentPlan>> generatePlan({
    required String studentId,
    required List<String> focusSubjects,
    required int availableMinutes,
    required String tenantId,
    required DateTime planDate,
  }) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY not found in environment variables');
      }

      // Initialize Gemini model
      final model = GenerativeModel(
        model: _modelName,
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
        ),
      );

      // Build the prompt
      final subjectsText = focusSubjects.join(', ');
      final prompt = _buildPrompt(subjectsText, availableMinutes);

      // Generate content
      final response = await model.generateContent([
        Content.text(
          '너는 입시 전문가야. 주어진 과목과 시간을 바탕으로 구체적인 학습 계획을 JSON 형태로 짜줘.\n\n$prompt',
        ),
      ]);

      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      // Clean and parse JSON response (handles markdown code blocks)
      final cleanedJson = JsonUtils.cleanJsonString(responseText);
      final plansJson = jsonDecode(cleanedJson) as Map<String, dynamic>;
      return _parsePlansFromJson(plansJson, studentId, tenantId, planDate);
    } catch (e) {
      throw Exception('Failed to generate plans with Gemini: $e');
    }
  }

  String _buildPrompt(String subjects, int availableMinutes) {
    return '''
다음 조건에 맞는 학습 플랜을 JSON 형식으로 만들어줘:

- 중점 과목: $subjects
- 가용 시간: $availableMinutes분
- 오늘 날짜: ${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일

응답 형식은 다음과 같은 JSON 구조여야 해:
{
  "plans": [
    {
      "subject": "과목명",
      "title": "구체적인 학습 제목",
      "expectedMinutes": 숫자(분),
      "notes": "학습 내용 설명"
    }
  ]
}

각 플랜은 구체적이고 실행 가능해야 해. 총 시간은 $availableMinutes분을 넘지 않도록 해.
''';
  }

  List<StudentPlan> _parsePlansFromJson(
    Map<String, dynamic> json,
    String studentId,
    String tenantId,
    DateTime planDate,
  ) {
    try {
      final plansList = json['plans'] as List<dynamic>?;
      if (plansList == null || plansList.isEmpty) {
        return [];
      }

      final planGroupId = _uuid.v4(); // All plans in a generation share the same group ID
      final now = DateTime.now();

      return plansList.map((planJson) {
        final plan = planJson as Map<String, dynamic>;
        final subject = plan['subject'] as String? ?? '기타';
        final title = plan['title'] as String? ?? '학습 플랜';
        final expectedMinutes = (plan['expectedMinutes'] as num?)?.toInt() ?? 30;
        final notes = plan['notes'] as String?;

        return StudentPlan(
          id: _uuid.v4(),
          tenantId: tenantId,
          studentId: studentId,
          planGroupId: planGroupId,
          planDate: planDate,
          expectedMinutes: expectedMinutes,
          titleOverride: title,
          notes: notes,
          status: PlanItemStatus.pending,
          type: PlanItemType.study,
          createdAt: now,
          updatedAt: now,
          meta: {
            'subject': subject,
            'generated_by': 'gemini',
            'generated_at': now.toIso8601String(),
          },
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to parse plans from Gemini response: $e');
    }
  }
}

