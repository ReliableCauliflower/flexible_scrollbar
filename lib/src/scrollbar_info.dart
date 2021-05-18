import 'package:flutter/rendering.dart';

class ScrollbarInfo {
  final bool isScrolling;
  final bool isDragging;

  final double thumbMainAxisSize;
  final double thumbMainAxisOffset;

  final AxisDirection scrollDirection;

  ScrollbarInfo({
    required this.isScrolling,
    required this.isDragging,
    required this.scrollDirection,
    required this.thumbMainAxisSize,
    required this.thumbMainAxisOffset,
  });
}
