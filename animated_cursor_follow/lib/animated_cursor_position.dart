import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AnimatedCursorState {
  const AnimatedCursorState({
    this.offset = Offset.zero,
    this.size = kDefaultSize,
    this.decoration = kDefaultDecoration,
  });

  static const Size kDefaultSize = Size(20, 20);
  static const BoxDecoration kDefaultDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(90)),
    color: Colors.black12,
  );

  final BoxDecoration decoration;
  final Offset offset;
  final Size size;
}

class AnimatedCursorProvider extends ChangeNotifier {
  AnimatedCursorProvider();

  AnimatedCursorState state = AnimatedCursorState();

  void changeCursor(GlobalKey key, {BoxDecoration? decoration}) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    state = AnimatedCursorState(
      size: renderBox.size,
      offset: renderBox
          .localToGlobal(Offset.zero)
          .translate(renderBox.size.width / 2, renderBox.size.height / 2),
      decoration: decoration ?? AnimatedCursorState.kDefaultDecoration,
    );
    notifyListeners();
  }

  void resetCursor() {
    state = AnimatedCursorState();
    notifyListeners();
  }

  void updateCursorPosition(Offset pos) {
    state = AnimatedCursorState(offset: pos);
    notifyListeners();
  }
}


class AnimatedCursor extends StatelessWidget {
  const AnimatedCursor({Key? key, this.child}) : super(key: key);

  final Widget? child;

  void _onCursorUpdate(PointerEvent event, BuildContext context) => context
      .read<AnimatedCursorProvider>()
      .updateCursorPosition(event.position);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AnimatedCursorProvider(),
      child: Consumer<AnimatedCursorProvider>(
        child: child,
        builder: (context, provider, child) {
          final state = provider.state;

          return Stack(
            children: [
              if (child != null) child,
              Positioned.fill(
                child: MouseRegion(
                  opaque: false,
                  onHover: (e) => _onCursorUpdate(e, context),
                ),
              ),
              Visibility(
                visible: state.offset != Offset.zero,
                child: AnimatedPositioned(
                  left: state.offset.dx - state.size.width / 2,
                  top: state.offset.dy - state.size.height / 2,
                  width: state.size.width,
                  height: state.size.height,
                  duration: Duration(milliseconds: 50),
                  child: IgnorePointer(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOutExpo,
                      width: state.size.width,
                      height: state.size.height,
                      decoration: state.decoration,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AnimatedCursorMouseRegion extends StatefulWidget {
  const AnimatedCursorMouseRegion({Key? key, this.child, this.decoration})
      : super(key: key);

  final Widget? child;
  final BoxDecoration? decoration;

  @override
  _AnimatedCursorMouseRegionState createState() =>
      _AnimatedCursorMouseRegionState();
}

class _AnimatedCursorMouseRegionState extends State<AnimatedCursorMouseRegion> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnimatedCursorProvider>();

    return MouseRegion(
      key: _key,
      opaque: false,
      onHover: (_) => cubit.changeCursor(_key, decoration: widget.decoration),
      onExit: (_) => cubit.resetCursor(),
      child: widget.child,
    );
  }
}
