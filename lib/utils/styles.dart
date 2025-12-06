import 'package:flutter/material.dart';

// =============================================================================
// COLORS
// =============================================================================

// Primary Colors
const Color primaryCyan = Color(0xFF66E0FF);
const Color primaryYellow = Color(0xFFFFCE52);

// Background Colors
const Color bgPrimary = Color(0xFF111827);
const Color bgSecondary = Color(0xFF1F2937);
const Color bgTertiary = Color(0xFF2D3748);
const Color bgInput = Color(0xFF374151);

// Text Colors
const Color textPrimary = Color(0xFFF3F4F6);
const Color textSecondary = Color(0xFF9CA3AF);
const Color textMuted = Color(0xFF6B7280);
const Color textDark = Color(0xFF111827);

// Status Colors
const Color statusTodo = Color(0xFF4B5563);
const Color statusInProgress = Color(0xFF3B82F6);
const Color statusDone = Color(0xFF10B981);
const Color statusBlocked = Color(0xFFEF4444);
const Color statusArchived = Color(0xFF9B4DCA);
const Color statusRescheduled = Color(0xFFF59E0B);

// Status Background Colors (for cards)
const Color statusBgTodo = Color(0xFF1E293B);
const Color statusBgInProgress = Color(0xFF1E3A5F);
const Color statusBgDone = Color(0xFF064E3B);
const Color statusBgBlocked = Color(0xFF450A0A);
const Color statusBgArchived = Color(0xFF3B1E54);
const Color statusBgRescheduled = Color(0xFF78350F);

// Priority Colors
const Color priorityLow = Color(0xFF10B981);
const Color priorityMedium = Color(0xFFFB923C);
const Color priorityHigh = Color(0xFFF87171);

// Difficulty Color
const Color difficultyStarColor = Color(0xFFFBBF24);

// Other Colors
const Color errorColor = Color(0xFFEF4444);
const Color successColor = Color(0xFF10B981);
const Color warningColor = Color(0xFFF59E0B);

// =============================================================================
// TEXT STYLES
// =============================================================================

const TextStyle headingXL = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: textPrimary,
);

const TextStyle headingLarge = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: textPrimary,
);

const TextStyle headingMedium = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: textPrimary,
);

const TextStyle headingSmall = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: textPrimary,
);

const TextStyle bodyLarge = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: textPrimary,
);

const TextStyle bodyMedium = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: textPrimary,
);

const TextStyle bodySmall = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: textPrimary,
);

const TextStyle labelLarge = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: textPrimary,
);

const TextStyle labelMedium = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: textPrimary,
);

const TextStyle labelSmall = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: textSecondary,
);

const TextStyle caption = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: textMuted,
);

// Accent text styles
const TextStyle accentTitle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: primaryCyan,
);

const TextStyle progressPercentage = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: textPrimary,
);

const TextStyle progressPercentageLarge = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// =============================================================================
// SHADOWS
// =============================================================================

BoxShadow get defaultShadow => BoxShadow(
  color: Colors.black.withValues(alpha: 0.3),
  blurRadius: 6,
  offset: const Offset(0, 2),
);

BoxShadow get lightShadow => BoxShadow(
  color: Colors.black.withValues(alpha: 0.2),
  blurRadius: 3,
  offset: const Offset(0, 1),
);

BoxShadow get glowShadow => BoxShadow(
  color: primaryCyan.withValues(alpha: 0.3),
  blurRadius: 12,
  offset: const Offset(0, 4),
);

BoxShadow get bottomNavShadow => BoxShadow(
  color: Colors.black.withValues(alpha: 0.3),
  blurRadius: 20,
  offset: const Offset(0, 4),
);

// =============================================================================
// DECORATIONS
// =============================================================================

BoxDecoration get cardDecoration => BoxDecoration(
  color: bgSecondary,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [defaultShadow],
);

BoxDecoration get inputDecoration => BoxDecoration(
  color: bgSecondary,
  borderRadius: BorderRadius.circular(8),
  border: Border.all(color: bgInput, width: 1),
);

BoxDecoration pillDecoration(bool isSelected) => BoxDecoration(
  color: isSelected ? Colors.white : Colors.transparent,
  borderRadius: BorderRadius.circular(20),
);

// =============================================================================
// BORDER RADIUS
// =============================================================================

const double radiusSmall = 8.0;
const double radiusMedium = 12.0;
const double radiusLarge = 16.0;
const double radiusXL = 20.0;
const double radiusRound = 30.0;

// =============================================================================
// SPACING
// =============================================================================

const double spacingXS = 4.0;
const double spacingS = 8.0;
const double spacingM = 12.0;
const double spacingL = 16.0;
const double spacingXL = 20.0;
const double spacingXXL = 24.0;
const double spacingXXXL = 32.0;

// =============================================================================
// PADDING
// =============================================================================

const EdgeInsets paddingAllS = EdgeInsets.all(8);
const EdgeInsets paddingAllM = EdgeInsets.all(12);
const EdgeInsets paddingAllL = EdgeInsets.all(16);
const EdgeInsets paddingAllXL = EdgeInsets.all(20);
const EdgeInsets paddingAllXXL = EdgeInsets.all(24);

const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: 8);
const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: 12);
const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: 16);

const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: 8);
const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: 12);
const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: 16);

// =============================================================================
// ICON SIZES
// =============================================================================

const double iconSizeSmall = 16.0;
const double iconSizeMedium = 20.0;
const double iconSizeLarge = 24.0;
const double iconSizeXL = 26.0;
const double iconSizeXXL = 28.0;

// =============================================================================
// STATUS MAPS (for convenience)
// =============================================================================

const Map<String, Color> statusColorMap = {
  'Todo 📝': statusTodo,
  'In Progress ⌛': statusInProgress,
  'Done ✅': statusDone,
  'Blocked ⛔': statusBlocked,
  'Archived 🗃️': statusArchived,
  'Rescheduled 🔄': statusRescheduled,
};

const Map<String, Color> statusBgColorMap = {
  'Todo 📝': statusBgTodo,
  'In Progress ⌛': statusBgInProgress,
  'Done ✅': statusBgDone,
  'Blocked ⛔': statusBgBlocked,
  'Archived 🗃️': statusBgArchived,
  'Rescheduled 🔄': statusBgRescheduled,
};

const Map<String, Color> priorityColorMap = {
  'Low 🌱': priorityLow,
  'Medium 🌿': priorityMedium,
  'High 🌳': priorityHigh,
};

// =============================================================================
// ANIMATION DURATIONS
// =============================================================================

const Duration animationFast = Duration(milliseconds: 150);
const Duration animationNormal = Duration(milliseconds: 200);
const Duration animationSlow = Duration(milliseconds: 300);
