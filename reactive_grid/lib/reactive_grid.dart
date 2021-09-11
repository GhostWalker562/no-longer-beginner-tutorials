import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class CursorDelegate {
  static final ValueNotifier<Offset> cursorPos =
      ValueNotifier<Offset>(Offset.zero);
}

class CursorTracker extends StatelessWidget {
  const CursorTracker({Key? key, this.child}) : super(key: key);

  final Widget? child;

  void _onCursorUpdate(PointerEvent event, BuildContext context) {
    if (event.position != Offset.zero) {
      CursorDelegate.cursorPos.value = event.position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null) child!,
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerMove: (e) => _onCursorUpdate(e, context),
            onPointerHover: (e) => _onCursorUpdate(e, context),
          ),
        ),
      ],
    );
  }
}

class ReactiveSquare extends StatefulWidget {
  const ReactiveSquare({
    Key? key,
    this.inverted = false,
    this.radius = 0,
    this.smallest = 0.1,
    this.largest = 1,
    this.floor = false,
    this.color,
  }) : super(key: key);

  final double smallest;
  final double largest;
  final double radius;
  final bool inverted;
  final bool floor;
  final Color? color;

  @override
  _ReactiveSquareState createState() => _ReactiveSquareState();
}

class _ReactiveSquareState extends State<ReactiveSquare>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Context will not be available during build... we will refresh right after the build has occured.
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  double _calculateDistance(Offset cursorPos) {
    // No need to calculate
    if (cursorPos == Offset.zero) {
      return (widget.inverted) ? widget.smallest : 1;
    }

    // Current square renderbox
    final square = context.findRenderObject() as RenderBox?;
    if (square == null) {
      return (widget.inverted) ? widget.smallest : 1;
    }

    // Find the center of the current square
    final centerPos =
        square.localToGlobal(square.size.bottomCenter(Offset.zero));

    // Find the distance from the center
    final distance = (centerPos - cursorPos).distance;

    // Find the circle around
    final threshold = square.size.longestSide + widget.radius;

    // Scaling math
    if (widget.floor) {
      return min(
        1,
        (distance / threshold).floorToDouble(),
      );
    } else if (widget.inverted) {
      return max(
        widget.smallest,
        (threshold / distance).clamp(widget.smallest, 1),
      );
    } else {
      return min(
        1,
        (distance / threshold).clamp(widget.smallest, 1),
      );
    }
  }

  Matrix4 _calculateRotation(Offset cursorPos) {
    if (cursorPos == Offset.zero) {
      return Matrix4.identity();
    }

    // Current square renderbox
    final square = context.findRenderObject() as RenderBox?;
    if (square == null) {
      return Matrix4.identity();
    }

    // Find the center of the current square
    final centerPos =
        square.localToGlobal(square.size.bottomCenter(Offset.zero));

    // Find the distance from the center
    final distance = (centerPos - cursorPos).distance;

    // Find the circle around
    final threshold = square.size.longestSide + widget.radius;

    // if (min(
    //       1,
    //       (distance / threshold).clamp(widget.smallest, 1),
    //     ) ==
    //     1) return Matrix4.identity();

    final distancePos = (centerPos - cursorPos);

    // Scaling math
    Matrix4 current = Matrix4.identity();
    // current.rotateX(pi / (distance.dy / square.size.width));
    // current.rotateY(-pi / (distance.dx / square.size.height));
    current.rotate(
        Vector3(
          (distancePos.dy/ square.size.width),
          -(distancePos.dx / square.size.height),
          0,
        ),
        distance / square.size.height/2);
    return current;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: CursorDelegate.cursorPos,
      builder: (context, value, child) {
        return Transform(
          transform: _calculateRotation(value),
          child: Transform.scale(
            scale: _calculateDistance(value),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.color ?? Colors.white,
          boxShadow: [
            BoxShadow(
              color: widget.color ?? Colors.white,
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
