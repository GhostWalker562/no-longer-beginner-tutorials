import 'package:flutter/material.dart';

class GradientBoxShadow {
  final BorderRadius? borderRadius;
  final double blurRadius;
  final Gradient gradient;

  GradientBoxShadow(
      {this.borderRadius, this.blurRadius = 0, required this.gradient});
}

class GradientRect extends StatelessWidget {
  const GradientRect({Key? key, this.child, required this.boxShadow})
      : super(key: key);

  final Widget? child;
  final GradientBoxShadow boxShadow;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GradientBoxShadowPainter(boxShadow),
      child: child,
    );
  }
}

class GradientBoxShadowPainter extends CustomPainter {
  final GradientBoxShadow boxShadow;

  GradientBoxShadowPainter(this.boxShadow);

  @override
  void paint(Canvas canvas, Size size) {
    final canvasRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final canvasRRect = boxShadow.borderRadius?.toRRect(canvasRect);

    final Paint paint = Paint()
      ..shader = boxShadow.gradient.createShader(canvasRect)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, boxShadow.blurRadius)
      ..style = PaintingStyle.fill;

    if (canvasRRect != null) {
      canvas.drawRRect(canvasRRect, paint);
    } else {
      canvas.drawRect(canvasRect, paint);
    }
  }

  @override
  bool shouldRepaint(GradientBoxShadowPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(GradientBoxShadowPainter oldDelegate) => false;
}
