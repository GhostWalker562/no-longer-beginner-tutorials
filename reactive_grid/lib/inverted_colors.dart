import 'package:flutter/material.dart';

class InvertColors extends StatelessWidget {
  final Widget child;

  const InvertColors({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(
        [
          -1, //RED
          0,
          0,
          0,
          255, //GREEN
          0,
          -1,
          0,
          0,
          255, //BLUE
          0,
          0,
          -1,
          0,
          255, //ALPHA
          0,
          0,
          0,
          1,
          0,
        ],
      ),
      child: child,
    );
  }
}
