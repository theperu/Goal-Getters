import 'package:flutter/material.dart';
import '../../../constants/style.dart';
import '../../../ui/extensions.dart';

const moodIcons = <int, IconData>{
  1: Icons.sentiment_very_dissatisfied,
  2: Icons.sentiment_dissatisfied,
  3: Icons.sentiment_neutral,
  4: Icons.sentiment_satisfied_alt,
  5: Icons.sentiment_very_satisfied,
};

const moodLabels = <int, String>{
  1: 'Very Bad',
  2: 'Bad',
  3: 'Okay',
  4: 'Good',
  5: 'Very Good',
};

const moodColors = <int, Color>{
  1: Color(0xFFDC2626),
  2: Color(0xFFF59E0B),
  3: Color(0xFF9CA3AF),
  4: Color(0xFFA7E4CD),
  5: Color(0xFF16A34A),
};

class MoodSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const MoodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: moodIcons.entries.map((entry) {
        final mood = entry.key;
        final icon = entry.value;
        final label = moodLabels[mood]!;
        final isSelected = selected == mood;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: mood < 5 ? spacingXS : 0),
            child: GestureDetector(
              onTap: () => onChanged(mood),
              child: AnimatedContainer(
                duration: animationFast,
                padding: const EdgeInsets.symmetric(vertical: spacingM),
                decoration: BoxDecoration(
                  color: isSelected ? primaryLavender : surface,
                  borderRadius: BorderRadius.circular(radiusLarge),
                  border: Border.all(
                    color: isSelected ? primaryLavender : borderSoft,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 28,
                      color: isSelected ? Colors.white : moodColors[mood],
                    ),
                    const SizedBox(height: spacingXS),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: caption.withColor(
                        isSelected ? Colors.white : textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
