import 'package:flutter/rendering.dart';

class ScrollbarInfo {
  final bool isScrolling;
  final bool isDragging;
  final Size thumbSize;
  final AxisDirection scrollDirection;

  ScrollbarInfo({
    this.isScrolling,
    this.isDragging,
    this.scrollDirection,
    this.thumbSize,
  });
}
