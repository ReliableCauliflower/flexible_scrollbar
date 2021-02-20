import 'package:flutter/rendering.dart';

class ScrollbarInfo {
  final bool isScrolling;
  final bool isDragging;

  final double thumbMainAxisSize;
  final double thumbMainAxisOffset;

  final AxisDirection scrollDirection;

  ScrollbarInfo({
    this.isScrolling,
    this.isDragging,
    this.scrollDirection,
    this.thumbMainAxisSize,
    this.thumbMainAxisOffset,
  });
}
