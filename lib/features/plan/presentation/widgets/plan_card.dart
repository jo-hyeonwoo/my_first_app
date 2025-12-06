import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/student_plan.dart';

class PlanCard extends StatelessWidget {
  final StudentPlan plan;
  final ValueChanged<bool?>? onToggleCompleted;

  const PlanCard({super.key, required this.plan, this.onToggleCompleted});

  Color _subjectColor(String? subjectId) {
    switch (subjectId) {
      case 'math':
        return Colors.indigo;
      case 'english':
        return Colors.teal;
      case 'korean':
        return Colors.deepOrange;
      case 'history':
        return Colors.brown;
      case 'science':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = plan.status == PlanItemStatus.completed;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: 88,
          child: Row(
            children: [
              Container(
                width: 8,
                height: double.infinity,
                color: _subjectColor(plan.subjectId),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.titleOverride ?? '무제',
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${plan.expectedMinutes ?? 0}분 • ${plan.notes ?? ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      // navigate to timer screen with plan as extra
                      context.push('/timer', extra: plan);
                    },
                  ),
                  Checkbox(
                    value: isCompleted,
                    onChanged: onToggleCompleted,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
