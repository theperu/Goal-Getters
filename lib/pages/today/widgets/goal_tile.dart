import 'package:flutter/material.dart';
import '../../../constants/style.dart';
import '../../../model/weekly_goal.dart';

class GoalTile extends StatelessWidget {
  final WeeklyGoal goal;
  final VoidCallback onToggle;
  final VoidCallback? onTap;

  const GoalTile({
    super.key,
    required this.goal,
    required this.onToggle,
    this.onTap,
  });

  bool get _isDone => goal.status == 'Done';

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isDone ? 0.55 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(radiusLarge),
          border: Border.all(color: borderSoft, width: 1.5),
          boxShadow: [shadowSm],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radiusLarge),
            onTap: onTap,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  _CompletionCircle(isDone: _isDone, onTap: onToggle),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      goal.name,
                      style: bodyLarge.copyWith(
                        color: _isDone ? textMuted : textMain,
                        decoration:
                            _isDone ? TextDecoration.lineThrough : null,
                        decorationColor: textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (goal.timeboxStart != null &&
                      goal.timeboxStart!.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: borderSoft,
                        borderRadius: BorderRadius.circular(radiusRound),
                      ),
                      child: Text(
                        goal.timeboxStart!,
                        style: bodySmall.copyWith(color: textSecondary),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletionCircle extends StatelessWidget {
  final bool isDone;
  final VoidCallback onTap;

  const _CompletionCircle({required this.isDone, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationFast,
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDone ? mint : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDone ? mint : borderSoft,
            width: 2,
          ),
        ),
        child: isDone
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }
}
