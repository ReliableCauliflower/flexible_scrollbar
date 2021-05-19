import 'dart:math' as math;

import 'package:flexible_scrollbar/flexible_scrollbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FlexibleScrollbarExampleApp());
}

class FlexibleScrollbarExampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  BarPosition barPosition = BarPosition.end;

  Axis scrollDirection = Axis.vertical;

  final int itemsCount = 99;

  final List<Color> itemsColors = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < itemsCount; ++i) {
      final int randomColorNumber =
          (math.Random().nextDouble() * 0xFFFFFF).toInt();
      itemsColors.add(Color(randomColorNumber).withOpacity(1.0));
    }
  }

  final double thumbWidth = 5;
  final double thumbDragWidth = 10;

  final animationDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (_, orientation) {
      final bool isVertical = orientation == Orientation.portrait;
      scrollDirection = isVertical ? Axis.vertical : Axis.horizontal;
      return Scaffold(
        body: FlexibleScrollbar(
          controller: scrollController,
          scrollThumbBuilder: (ScrollbarInfo info) {
            return AnimatedContainer(
              width: isVertical
                  ? info.isDragging
                      ? thumbDragWidth
                      : thumbWidth
                  : info.thumbMainAxisSize,
              height: !isVertical
                  ? info.isDragging
                      ? thumbDragWidth
                      : thumbWidth
                  : info.thumbMainAxisSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(info.isDragging ? 1 : 0.6),
              ),
              duration: animationDuration,
            );
          },
          scrollLabelBuilder: (info) {
            final screenSize = MediaQuery.of(context).size;
            final double cellSize =
                (isVertical ? screenSize.width : screenSize.height) / 3;
            final int lineNum =
                (scrollController.position.pixels ~/ cellSize) + 1;
            return AnimatedContainer(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(info.isDragging ? 1 : 0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              duration: animationDuration,
              child: Text(
                '${isVertical ? 'Row' : 'Column'} #$lineNum',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
          scrollLineCrossAxisSize: thumbDragWidth,
          barPosition: barPosition,
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            controller: scrollController,
            itemCount: 99,
            scrollDirection: scrollDirection,
            itemBuilder: (context, int index) {
              final randomColor = itemsColors[index];
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: randomColor,
                child: Center(
                  child: Text(
                    (++index).toString(),
                    style: TextStyle(
                      color: randomColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Transform.rotate(
            angle: scrollDirection == Axis.vertical ? math.pi / 2 : 0,
            child: Icon(Icons.height),
          ),
          onPressed: () => setState(() {
            switch (barPosition) {
              case BarPosition.start:
                barPosition = BarPosition.end;
                break;
              case BarPosition.end:
                barPosition = BarPosition.start;
                break;
            }
          }),
        ),
      );
    });
  }
}
