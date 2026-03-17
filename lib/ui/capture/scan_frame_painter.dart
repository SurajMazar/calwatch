import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const cornerLen = 40.0;
    const radius = 16.0;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLen)
        ..lineTo(0, radius)
        ..arcToPoint(const Offset(radius, 0),
            radius: const Radius.circular(radius))
        ..lineTo(cornerLen, 0),
      paint,
    );

    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLen, 0)
        ..lineTo(size.width - radius, 0)
        ..arcToPoint(Offset(size.width, radius),
            radius: const Radius.circular(radius))
        ..lineTo(size.width, cornerLen),
      paint,
    );

    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLen)
        ..lineTo(0, size.height - radius)
        ..arcToPoint(Offset(radius, size.height),
            radius: const Radius.circular(radius), clockwise: false)
        ..lineTo(cornerLen, size.height),
      paint,
    );

    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLen, size.height)
        ..lineTo(size.width - radius, size.height)
        ..arcToPoint(Offset(size.width, size.height - radius),
            radius: const Radius.circular(radius), clockwise: false)
        ..lineTo(size.width, size.height - cornerLen),
      paint,
    );

    // Scan line
    final scanPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      scanPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
