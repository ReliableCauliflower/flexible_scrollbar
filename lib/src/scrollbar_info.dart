import 'package:flutter/rendering.dart';

class ScrollbarInfo {
  /// Changes when the user starts/strops the scroll body scrolling.
  /// The isDragging is not affected by it
  final bool isScrolling;

  /// Changes when the user starts/strops to drag the scroll thumb.
  /// The isScrolling is not affected by it
  final bool isDragging;

  /// Contains the calculated depending on the scroll body size thumb length
  final double thumbMainAxisSize;

  /// Contains the offset in pixels of the scroll thumb from the starting
  /// position
  final double thumbMainAxisOffset;

  /// Has the scroll body scroll direction in it (up/down/left/right)
  final AxisDirection scrollDirection;

  ScrollbarInfo({
    required this.isScrolling,
    required this.isDragging,
    required this.scrollDirection,
    required this.thumbMainAxisSize,
    required this.thumbMainAxisOffset,
  });
}
