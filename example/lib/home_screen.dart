import 'package:flexible_scrollbar/flexible_scrollbar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FlexibleScrollbar(
          controller: scrollController,
          scrollThumb: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            controller: scrollController,
            itemCount: 99,
            itemBuilder: (context, int index) {
              final int randomColorNumber =
                  (math.Random().nextDouble() * 0xFFFFFF).toInt();
              final Color randomColor = Color(randomColorNumber).withOpacity(1.0);
              return Container(
                width: double.infinity,
                height: 100,
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
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => setState(() {}),
      ),
    );
  }
}
