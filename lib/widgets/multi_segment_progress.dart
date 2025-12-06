import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/styles.dart';

/// A segment for the multi-segment circular progress
class ProgressSegment {
  final double value;
  final Color color;

  const ProgressSegment(this.value, this.color);
}

/// A custom painter for multi-colored circular progress
/// Used in goals_list.dart for the summary section
class MultiSegmentCirclePainter extends CustomPainter {
  final List<ProgressSegment> segments;
  final Color backgroundColor;
  final double strokeWidth;

  MultiSegmentCirclePainter({
    required this.segments,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw segments
    double startAngle = -90 * (math.pi / 180); // Start from top

    for (final segment in segments) {
      if (segment.value <= 0) continue;

      final sweepAngle = segment.value * 2 * math.pi;

      final segmentPaint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        segmentPaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// A widget that wraps the MultiSegmentCirclePainter
class MultiSegmentCircularProgress extends StatelessWidget {
  final List<ProgressSegment> segments;
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Widget? center;

  const MultiSegmentCircularProgress({
    super.key,
    required this.segments,
    this.size = 64,
    this.strokeWidth = 6,
    this.backgroundColor = bgInput,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: MultiSegmentCirclePainter(
              segments: segments,
              backgroundColor: backgroundColor,
              strokeWidth: strokeWidth,
            ),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}
