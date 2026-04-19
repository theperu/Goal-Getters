import 'package:flutter/material.dart';

// =============================================================================
// COLORS — Lavender Logic Design System
// =============================================================================

// Signature Accents
const Color primaryLavender = Color(0xFF6128F0); // Primary action
const Color lavender = Color(0xFFD4C4FB);         // Active state highlight
const Color mint = Color(0xFFA7E4CD);              // Completion / success
const Color peach = Color(0xFFFFCBA4);             // Warning / overflow

// Surface Hierarchy
const Color background = Color(0xFFFDFDFB);       // Canvas / base
const Color surface = Color(0xFFFFFFFF);           // Cards & interaction points
const Color borderSoft = Color(0xFFF0F0EE);        // Subtle separation (no harsh lines)

// Text Colors — never use pure black
const Color textMain = Color(0xFF3A3A38);           // Primary text
const Color textSecondary = Color(0xFF7A7A78);      // Secondary / muted
const Color textMuted = Color(0xFFA0A09E);          // Captions, placeholders

// Legacy aliases (kept for backward compat during transition)
const Color primaryCyan = primaryLavender;
const Color primaryYellow = peach;
const Color bgPrimary = background;
const Color bgSecondary = surface;
const Color bgTertiary = borderSoft;
const Color bgInput = borderSoft;
const Color textPrimary = textMain;
const Color textDark = textMain;

// Status Colors
const Color statusTodo = Color(0xFF9CA3AF);
const Color statusInProgress = Color(0xFF6128F0);   // Lavender accent
const Color statusDone = Color(0xFF16A34A);          // Green / mint family
const Color statusBlocked = Color(0xFFDC2626);
const Color statusArchived = Color(0xFF7C3AED);
const Color statusRescheduled = Color(0xFFD97706);

// Status Background Colors (light tinted surfaces)
const Color statusBgTodo = Color(0xFFF3F4F6);
const Color statusBgInProgress = Color(0xFFEDE9FE);  // Light lavender
const Color statusBgDone = Color(0xFFD1FAE5);         // Light mint
const Color statusBgBlocked = Color(0xFFFEE2E2);
const Color statusBgArchived = Color(0xFFF3E8FF);
const Color statusBgRescheduled = Color(0xFFFEF3C7);

// Priority Colors
const Color priorityLow = Color(0xFF16A34A);
const Color priorityMedium = Color(0xFFF59E0B);
const Color priorityHigh = Color(0xFFDC2626);

// Difficulty Color
const Color difficultyStarColor = Color(0xFFFBBF24);

// Semantic Colors
const Color errorColor = Color(0xFFDC2626);
const Color successColor = Color(0xFF16A34A);
const Color warningColor = Color(0xFFF59E0B);

// =============================================================================
// TEXT STYLES — Plus Jakarta Sans (set via AppTheme textTheme)
// Design hierarchy: Display 28px, Body 16px, Caption 12-13px
// =============================================================================

const TextStyle headingXL = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w700,
  color: textMain,
);

const TextStyle headingLarge = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: textMain,
);

const TextStyle headingMedium = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: textMain,
);

const TextStyle headingSmall = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: textMain,
);

const TextStyle bodyLarge = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: textMain,
);

const TextStyle bodyMedium = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: textMain,
);

const TextStyle bodySmall = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: textMain,
);

const TextStyle labelLarge = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: textMain,
);

const TextStyle labelMedium = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: textMain,
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
  color: primaryLavender,
);

const TextStyle progressPercentage = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: textMain,
);

const TextStyle progressPercentageLarge = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: textMain,
);

// =============================================================================
// SHADOWS — Soft, ambient (never harsh)
// =============================================================================

BoxShadow get shadowSm => BoxShadow(
  color: Colors.black.withValues(alpha: 0.05),
  blurRadius: 4,
  offset: const Offset(0, 2),
);

BoxShadow get shadowLg => BoxShadow(
  color: Colors.black.withValues(alpha: 0.10),
  blurRadius: 16,
  offset: const Offset(0, 6),
);

// Legacy aliases
BoxShadow get defaultShadow => shadowSm;
BoxShadow get lightShadow => shadowSm;
BoxShadow get glowShadow => shadowLg;
BoxShadow get bottomNavShadow => shadowLg;

// =============================================================================
// DECORATIONS — Lavender Logic: surface + border-soft, no dark backgrounds
// =============================================================================

BoxDecoration get cardDecoration => BoxDecoration(
  color: surface,
  borderRadius: BorderRadius.circular(radiusLarge),
  border: Border.all(color: borderSoft, width: 2),
  boxShadow: [shadowSm],
);

BoxDecoration get inputDecoration => BoxDecoration(
  color: surface,
  borderRadius: BorderRadius.circular(radiusLarge),
  border: Border.all(color: borderSoft, width: 2),
);

BoxDecoration pillDecoration(bool isSelected) => BoxDecoration(
  color: isSelected ? lavender : Colors.transparent,
  borderRadius: BorderRadius.circular(radiusRound),
);

// =============================================================================
// BORDER RADIUS — interactive elements ≥ 16px (1rem)
// =============================================================================

const double radiusSmall = 12.0;
const double radiusMedium = 16.0;
const double radiusLarge = 16.0;
const double radiusXL = 20.0;
const double radiusRound = 999.0;

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
// STATUS MAPS
// =============================================================================

const Map<String, Color> statusColorMap = {
  'Todo': statusTodo,
  'In Progress': statusInProgress,
  'Done': statusDone,
  'Blocked': statusBlocked,
  'Archived': statusArchived,
  'Rescheduled': statusRescheduled,
};

const Map<String, Color> statusBgColorMap = {
  'Todo': statusBgTodo,
  'In Progress': statusBgInProgress,
  'Done': statusBgDone,
  'Blocked': statusBgBlocked,
  'Archived': statusBgArchived,
  'Rescheduled': statusBgRescheduled,
};

const Map<String, Color> priorityColorMap = {
  'Low': priorityLow,
  'Medium': priorityMedium,
  'High': priorityHigh,
};

// =============================================================================
// ANIMATION DURATIONS
// =============================================================================

const Duration animationFast = Duration(milliseconds: 150);
const Duration animationNormal = Duration(milliseconds: 200);
const Duration animationSlow = Duration(milliseconds: 300);
