import 'package:flutter/material.dart';
import '../../constants/goal_icons.dart';
import '../../constants/habit_colors.dart';
import '../../constants/style.dart';
import '../../model/habit.dart';

class HabitForm extends StatefulWidget {
  final Habit? habit;

  const HabitForm({super.key, this.habit});

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  late final TextEditingController _nameController;
  late String _selectedIcon;
  late String _selectedColor;
  late int _timesPerWeek;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _selectedIcon = widget.habit?.icon ?? 'star';
    _selectedColor = widget.habit?.color ?? habitColorChoices.first.key;
    _timesPerWeek = widget.habit?.timesPerWeek ?? 7;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final habit = Habit(
      id: widget.habit?.id,
      name: name,
      icon: _selectedIcon,
      color: _selectedColor,
      timesPerWeek: _timesPerWeek,
      createdAt: widget.habit?.createdAt,
      updatedAt: widget.habit?.updatedAt,
    );
    Navigator.pop(context, habit);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;

    return Scaffold(
      backgroundColor: bgPrimary,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Habit' : 'New Habit',
            style: headingMedium),
        backgroundColor: bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Name field
          Text('Name', style: labelMedium),
          const SizedBox(height: 8),
          Container(
            decoration: inputDecoration,
            child: TextField(
              controller: _nameController,
              style: bodyLarge,
              decoration: const InputDecoration(
                hintText: 'e.g. Morning exercise',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Times per week
          Text('Times per week', style: labelMedium),
          const SizedBox(height: 12),
          Row(
            children: List.generate(7, (i) {
              final value = i + 1;
              final isSelected = _timesPerWeek == value;
              return Padding(
                padding: EdgeInsets.only(right: i < 6 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _timesPerWeek = value),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? primaryLavender : surface,
                      borderRadius: BorderRadius.circular(radiusSmall),
                      border: Border.all(
                        color: isSelected ? primaryLavender : borderSoft,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$value',
                      style: bodyMedium.copyWith(
                        color: isSelected ? Colors.white : textMain,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          // Icon picker
          Text('Icon', style: labelMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: goalIconChoices.map((gi) {
              final isSelected = _selectedIcon == gi.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedIcon = gi.key),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryLavender.withValues(alpha: 0.12)
                        : surface,
                    borderRadius: BorderRadius.circular(radiusSmall),
                    border: Border.all(
                      color: isSelected ? primaryLavender : borderSoft,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    gi.icon,
                    size: 22,
                    color: isSelected ? primaryLavender : textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Color picker
          Text('Color', style: labelMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: habitColorChoices.map((hc) {
              final isSelected = _selectedColor == hc.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = hc.key),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: hc.color,
                    borderRadius: BorderRadius.circular(radiusSmall),
                    border: Border.all(
                      color: isSelected ? textMain : Colors.transparent,
                      width: isSelected ? 3 : 0,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 22)
                      : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 40),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryLavender,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radiusLarge),
                ),
                elevation: 0,
              ),
              child: Text(
                isEditing ? 'Save Changes' : 'Create Habit',
                style: bodyLarge.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
