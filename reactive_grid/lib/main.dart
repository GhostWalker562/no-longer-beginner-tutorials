import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'reactive_grid.dart';
import 'inverted_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController controller = PageController();

  Widget _buildGridView(BuildContext context,
      {required IndexedWidgetBuilder itemBuilder}) {
    return Center(
      child: SizedBox(
        width: 200,
        height:200,
        child: GridView.builder(
          clipBehavior: Clip.none,
          shrinkWrap: true,
          itemCount:  9 ?? (1200 / 5).round(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CursorTracker(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Content
            PageView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: controller,
              children: [
                _buildGridView(
                  context,
                  itemBuilder: (context, index) {
                    return const Center(
                      child: ReactiveSquare(
                        radius: 50,
                        smallest: 0.5,
                        floor: true,
                      ),
                    );
                  },
                ),
                _buildGridView(
                  context,
                  itemBuilder: (context, index) {
                    return const Center(
                      child: ReactiveSquare(
                        radius: 50,
                        smallest: 0.5,
                        inverted: true,
                        color: Color(0xFFD013A1),
                      ),
                    );
                  },
                ),
                _buildGridView(
                  context,
                  itemBuilder: (context, index) {
                    return const Center(
                      child: ReactiveSquare(
                        radius: 100,
                        smallest: 0.25,
                        color: Color(0xFFCA1D21),
                      ),
                    );
                  },
                ),
                _buildGridView(
                  context,
                  itemBuilder: (context, index) {
                    final int row = ((index / 40).round() - 1).clamp(0, 5);
                    const List<Color> colors = [
                      Color(0xFF270E46),
                      Color(0xFF862784),
                      Color(0xFFEE3548),
                      Color(0xFFF6EC3C),
                      Color(0xFFD04C9D),
                      Color(0xFF4B4FA2),
                    ];
                    return Center(
                      child: ReactiveSquare(
                        radius: 100,
                        smallest: 0.1,
                        inverted: true,
                        color: colors[row],
                      ),
                    );
                  },
                ),
              ],
            ),

            //  Pagination Controls
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
                      onPressed: () => controller.previousPage(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutExpo,
                      ),
                    ),
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      onPressed: () => controller.nextPage(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Vignette
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.125,
                  child: InvertColors(
                    child: Image.network(
                      '''
http://static1.squarespace.com/static/58f66a4b5016e1f7a7bf289f/58fe40dafc0155f87ab7b4fe/58fe40defc0155f87ab7b6ec/1493057758061/Vignette.jpg?format=original''',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
