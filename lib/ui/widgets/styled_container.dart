import 'package:flutter/material.dart';
import '../../constants/style.dart';

/// A styled container with rounded corners, consistent background and shadow
/// Used throughout the app for cards and sections
class StyledContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final bool hasShadow;

  const StyledContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = radiusMedium,
    this.backgroundColor,
    this.width,
    this.height,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? bgSecondary,
        boxShadow: hasShadow ? [defaultShadow] : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: padding != null
          ? Padding(padding: padding!, child: child)
          : child,
    );
  }
}
