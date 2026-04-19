import 'package:flutter/material.dart';

/// Spacing scale based on a 16px base unit.
class Sizes {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  // Border radius
  static const double borderRadiusSm = 4;
  static const double borderRadius = 8;
  static const double borderRadiusLg = 16;

  // Responsive edge insets
  static const double phoneEdgeInsets = 16;
  static const double tabletEdgeInsets = 24;
  static const double desktopEdgeInsets = 32;

  static double responsiveInsets(BuildContext context) {
    switch (context.screenSize()) {
      case ScreenSize.mobile:
        return phoneEdgeInsets;
      case ScreenSize.tablet:
        return tabletEdgeInsets;
      case ScreenSize.desktop:
        return desktopEdgeInsets;
    }
  }
}

enum ScreenSize { mobile, tablet, desktop }

class BreakPoint {
  final double tablet;
  final double desktop;

  const BreakPoint({required this.tablet, required this.desktop});

  static const material = BreakPoint(tablet: 600, desktop: 960);
  static const android = BreakPoint(tablet: 600, desktop: 840);
  static const iOS = BreakPoint(tablet: 767, desktop: 1024);
  static const windows = BreakPoint(tablet: 640, desktop: 1007);
}

extension ScreenSizeContext on BuildContext {
  ScreenSize screenSize({BreakPoint breakPoint = BreakPoint.material}) {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= breakPoint.desktop) return ScreenSize.desktop;
    if (width >= breakPoint.tablet) return ScreenSize.tablet;
    return ScreenSize.mobile;
  }

  bool get isMobile => screenSize() == ScreenSize.mobile;
  bool get isTablet => screenSize() == ScreenSize.tablet;
  bool get isDesktop => screenSize() == ScreenSize.desktop;
  bool get isTabletOrLarger => !isMobile;
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;
}
