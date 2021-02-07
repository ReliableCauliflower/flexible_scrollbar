library flexible_scrollbar;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum BarPosition { start, end }

class FlexibleScrollbar extends StatefulWidget {
  final ScrollController controller;

  final Widget child;
  final Widget scrollThumb;

  final bool isAdjustScrollThumb;
  final bool isAlwaysVisible;
  final bool isFadeScrollLine;
  final bool isJumpOnScrollLineTapped;
  final bool isDraggable;

  final double maxScrollViewMainAxisSize;
  final double maxScrollViewCrossAxisSize;
  final double scrollLineCrossAxisPositionRatio;
  final double scrollLineOffset;
  final double thumbMainAxisSize;
  final double thumbCrossAxisSize;
  final double thumbMainAxisMinSize;
  final double scrollLineCrossAxisPadding;

  final Duration thumbFadeStartDuration;
  final Duration thumbFadeDuration;

  final BarPosition barPosition;

  final BoxDecoration scrollLineDecoration;

  final Function(DragStartDetails details) onDragStart;
  final Function(DragEndDetails details) onDragEnd;
  final Function(DragUpdateDetails details) onDragUpdate;

  FlexibleScrollbar({
    Key key,
    @required this.child,
    @required this.controller,
    this.scrollThumb,
    this.maxScrollViewMainAxisSize,
    this.maxScrollViewCrossAxisSize,
    this.scrollLineCrossAxisPositionRatio,
    this.scrollLineOffset,
    this.onDragStart,
    this.onDragEnd,
    this.onDragUpdate,
    this.thumbMainAxisMinSize,
    this.isAdjustScrollThumb = true,
    this.isAlwaysVisible = false,
    this.isFadeScrollLine = false,
    this.isJumpOnScrollLineTapped = true,
    this.isDraggable = true,
    this.thumbCrossAxisSize = 10,
    this.thumbMainAxisSize = 40,
    this.thumbFadeStartDuration,
    this.thumbFadeDuration,
    this.barPosition = BarPosition.end,
    this.scrollLineDecoration,
    this.scrollLineCrossAxisPadding,
  })  : assert(child != null),
        assert(controller != null),
        super(key: key);

  @override
  _FlexibleScrollbarState createState() => _FlexibleScrollbarState();
}

class _FlexibleScrollbarState extends State<FlexibleScrollbar> {
  final GlobalKey scrollAreaKey = GlobalKey();

  double barOffset = 0.0;
  double viewOffset = 0.0;
  double barMaxScrollExtent;
  double thumbMainAxisSize;

  bool isDragInProcess = false;
  bool isScrollInProcess = false;
  bool isThumbNeeded = false;
  bool isJumpingTo = false;
  bool isJumpTapUp = true;
  bool isScrollable = false;

  AxisDirection scrollAxisDirection;

  double scrollAreaWidth;
  double scrollAreaHeight;

  bool get isScrolling => isDragInProcess || isScrollInProcess || !isJumpTapUp;

  bool isVertical = true;

  bool get reverse {
    if (isVertical && scrollAxisDirection == AxisDirection.up) {
      return true;
    }
    if (!isVertical && scrollAxisDirection == AxisDirection.left) {
      return true;
    }
    return false;
  }

  bool get isEnd => widget.barPosition == BarPosition.end;

  int countDownCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      calculateScrollAreaFields();
    });
  }

  double get mainAxisScrollAreaSize =>
      isVertical ? scrollAreaHeight : scrollAreaWidth;

  double get crossAxisScrollAreaSize =>
      !isVertical ? scrollAreaHeight : scrollAreaWidth;

  double get widthByKey {
    return scrollAreaKey.currentContext.size.width;
  }

  double get heightByKey {
    return scrollAreaKey.currentContext.size.height;
  }

  double get viewMaxScrollExtent => widget.controller.position.maxScrollExtent;

  double get maxExtentToAreaHeightRatio =>
      (scrollAreaHeight + viewMaxScrollExtent) / scrollAreaHeight;

  double get maxExtentToAreaWidthRatio =>
      (scrollAreaWidth + viewMaxScrollExtent) / scrollAreaWidth;

  double getScrollViewDelta(double barDelta) {
    return barDelta * viewMaxScrollExtent / barMaxScrollExtent;
  }

  double getBarDelta(double scrollViewDelta) {
    return scrollViewDelta * barMaxScrollExtent / viewMaxScrollExtent;
  }

  void onDragStart(DragStartDetails details) {
    setState(() {
      isDragInProcess = true;
    });
    if (widget.onDragStart != null) {
      onDragStart(details);
    }
  }

  void onDragEnd(DragEndDetails details) {
    setState(() {
      isDragInProcess = false;
      isJumpTapUp = true;
    });
    startHideThumbCountdown();
    if (widget.onDragEnd != null) {
      widget.onDragEnd(details);
    }
  }

  void onDragUpdate(DragUpdateDetails details) {
    setState(() {
      final double mainAxisCoordinate =
          isVertical ? details.delta.dy : details.delta.dx;

      barOffset += reverse ? -mainAxisCoordinate : mainAxisCoordinate;

      if (barOffset < 0) {
        barOffset = 0;
      }
      if (barOffset > barMaxScrollExtent) {
        barOffset = barMaxScrollExtent;
      }

      double viewDelta = getScrollViewDelta(mainAxisCoordinate);

      viewOffset = widget.controller.position.pixels +
          (reverse ? -viewDelta : viewDelta);
      if (viewOffset < widget.controller.position.minScrollExtent) {
        viewOffset = widget.controller.position.minScrollExtent;
      }
      if (viewOffset > viewMaxScrollExtent) {
        viewOffset = viewMaxScrollExtent;
      }
      widget.controller.jumpTo(viewOffset);
    });
    if (widget.onDragUpdate != null) {
      widget.onDragUpdate(details);
    }
  }

  void onScrollLineTapped(TapDownDetails details) {
    if (widget.isJumpOnScrollLineTapped) {
      setState(() {
        isThumbNeeded = true;
        isJumpTapUp = false;
        final mainAxisCoordinate =
            isVertical ? details.localPosition.dy : details.localPosition.dx;

        if (reverse &&
            mainAxisCoordinate < mainAxisScrollAreaSize - barOffset &&
            mainAxisCoordinate >
                mainAxisScrollAreaSize - (barOffset + thumbMainAxisSize)) {
          return;
        } else if (mainAxisCoordinate > barOffset &&
            mainAxisCoordinate < barOffset + thumbMainAxisSize) {
          return;
        }

        double offset;
        if (reverse) {
          offset = mainAxisScrollAreaSize -
              mainAxisCoordinate -
              (thumbMainAxisSize / 2);
        } else {
          offset = mainAxisCoordinate - (thumbMainAxisSize / 2);
        }
        if (offset.isNegative) {
          offset = 0;
        } else if (offset + thumbMainAxisSize > mainAxisScrollAreaSize) {
          offset = mainAxisScrollAreaSize - thumbMainAxisSize;
        }

        barOffset = offset;

        final maxOffset = mainAxisScrollAreaSize - thumbMainAxisSize;
        final offsetToSizeRatio = maxOffset / viewMaxScrollExtent;

        final scrollPosition = offset / offsetToSizeRatio;
        isJumpingTo = true;
        widget.controller.jumpTo(scrollPosition);
      });
    }
  }

  bool changePosition(ScrollNotification notification) {
    if (isDragInProcess) {
      return false;
    }
    setState(() {
      if (notification is ScrollUpdateNotification) {
        final barDelta = getBarDelta(notification.scrollDelta);
        barOffset += barDelta;

        if (barOffset < 0) {
          barOffset = 0;
        }
        if (barOffset > barMaxScrollExtent) {
          barOffset = barMaxScrollExtent;
        }

        viewOffset += notification.scrollDelta;
        if (viewOffset < widget.controller.position.minScrollExtent) {
          viewOffset = widget.controller.position.minScrollExtent;
        }
        if (viewOffset > viewMaxScrollExtent) {
          viewOffset = viewMaxScrollExtent;
        }
      }
    });
    return true;
  }

  void calculateScrollAreaFields() {
    final double width = widthByKey;
    final double height = heightByKey;

    scrollAxisDirection = widget.controller.position.axisDirection;
    isVertical = scrollAxisDirection == AxisDirection.up ||
        scrollAxisDirection == AxisDirection.down;

    if (isVertical) {
      scrollAreaWidth = widget.maxScrollViewCrossAxisSize ??
          width ??
          MediaQuery.of(context).size.width;
      scrollAreaHeight = widget.maxScrollViewMainAxisSize ??
          height ??
          MediaQuery.of(context).size.height;
    } else {
      scrollAreaWidth = widget.maxScrollViewMainAxisSize ??
          width ??
          MediaQuery.of(context).size.width;
      scrollAreaHeight = widget.maxScrollViewCrossAxisSize ??
          height ??
          MediaQuery.of(context).size.height;
    }
    if (viewMaxScrollExtent != 0.0) {
      isScrollable = true;
      if (widget.isAdjustScrollThumb) {
        double thumbMinSize;
        if (widget.thumbMainAxisMinSize != null) {
          thumbMinSize = thumbMinSize;
        } else {
          thumbMinSize = mainAxisScrollAreaSize * 0.1;
        }
        thumbMainAxisSize = mainAxisScrollAreaSize /
            (isVertical
                ? maxExtentToAreaHeightRatio
                : maxExtentToAreaWidthRatio);
        if (thumbMainAxisSize < thumbMinSize) {
          thumbMainAxisSize = thumbMinSize;
        }
      } else {
        thumbMainAxisSize = widget.thumbMainAxisSize;
      }
      barMaxScrollExtent = mainAxisScrollAreaSize - thumbMainAxisSize;
      setState(() {
        isThumbNeeded = widget.isAlwaysVisible;
      });
    } else {
      isScrollable = false;
    }
  }

  void startHideThumbCountdown() {
    if (widget.isAlwaysVisible) {
      return;
    }
    final currentCountdownNumber = ++countDownCount;
    Future.delayed(
        widget.thumbFadeStartDuration ?? const Duration(milliseconds: 1000),
        () {
      if (currentCountdownNumber == countDownCount && !isScrolling && mounted) {
        setState(() {
          isThumbNeeded = false;
          countDownCount = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Alignment scrollLineAlignment;
    if (widget.barPosition == BarPosition.start) {
      if (reverse) {
        if (isVertical) {
          scrollLineAlignment = Alignment.bottomLeft;
        } else {
          scrollLineAlignment = Alignment.topRight;
        }
      } else {
        scrollLineAlignment = Alignment.topLeft;
      }
    } else {
      if (reverse) {
        scrollLineAlignment = Alignment.bottomRight;
      } else {
        if (isVertical) {
          scrollLineAlignment = Alignment.topRight;
        } else {
          scrollLineAlignment = Alignment.bottomLeft;
        }
      }
    }

    double scrollLineOffset = widget.scrollLineOffset ?? 0;
    if (widget.scrollLineCrossAxisPositionRatio != null &&
        widget.scrollLineCrossAxisPositionRatio >= 0 &&
        scrollLineOffset == 0) {
      scrollLineOffset =
          (crossAxisScrollAreaSize * widget.scrollLineCrossAxisPositionRatio) -
              (widget.thumbCrossAxisSize / 2);

      final maxOffset = crossAxisScrollAreaSize - widget.thumbCrossAxisSize;
      if (scrollLineOffset > maxOffset) {
        scrollLineOffset = maxOffset;
      }
    }

    final double crossAxisPadding = widget.scrollLineCrossAxisPadding ?? 0;

    return NotificationListener<ScrollNotification>(
      key: scrollAreaKey,
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification) {
          isScrollInProcess = false;
          isJumpingTo = false;
          startHideThumbCountdown();
        } else if (notification is ScrollStartNotification) {
          isScrollInProcess = true;
          setState(() {
            isThumbNeeded = true;
          });
        }
        if (isJumpingTo) {
          return true;
        }
        return changePosition(notification);
      },
      child: Stack(
        alignment: scrollLineAlignment,
        children: <Widget>[
          widget.child,
          Padding(
            padding: EdgeInsets.only(
              left: isVertical && !isEnd ? scrollLineOffset : 0,
              right: isVertical && isEnd ? scrollLineOffset : 0,
              top: !isVertical && !isEnd ? scrollLineOffset : 0,
              bottom: !isVertical && isEnd ? scrollLineOffset : 0,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart:
                  isVertical && widget.isDraggable ? onDragStart : null,
              onVerticalDragUpdate:
                  isVertical && widget.isDraggable ? onDragUpdate : null,
              onVerticalDragEnd:
                  isVertical && widget.isDraggable ? onDragEnd : null,
              onHorizontalDragStart:
                  !isVertical && widget.isDraggable ? onDragStart : null,
              onHorizontalDragUpdate:
                  !isVertical && widget.isDraggable ? onDragUpdate : null,
              onHorizontalDragEnd:
                  !isVertical && widget.isDraggable ? onDragEnd : null,
              onTapDown: onScrollLineTapped,
              onTapUp: (TapUpDetails details) {
                startHideThumbCountdown();
                isJumpTapUp = true;
              },
              child: animatedFade(
                isAlwaysVisible: !widget.isFadeScrollLine,
                child: Container(
                  height: isVertical
                      ? isScrollable
                          ? scrollAreaHeight
                          : null
                      : widget.thumbCrossAxisSize + 2 * crossAxisPadding,
                  width: isVertical
                      ? widget.thumbCrossAxisSize + 2 * crossAxisPadding
                      : isScrollable
                          ? scrollAreaWidth
                          : null,
                  decoration: widget.scrollLineDecoration,
                  padding: EdgeInsets.only(
                    top: isVertical && !reverse ? barOffset : crossAxisPadding,
                    bottom:
                        isVertical && reverse ? barOffset : crossAxisPadding,
                    left:
                        !isVertical && !reverse ? barOffset : crossAxisPadding,
                    right:
                        !isVertical && reverse ? barOffset : crossAxisPadding,
                  ),
                  alignment: scrollLineAlignment,
                  child: buildScrollThumb(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScrollThumb() {
    return animatedFade(
      isAlwaysVisible: widget.isAlwaysVisible,
      child: Container(
        height: isVertical ? thumbMainAxisSize : null,
        width: isVertical ? null : thumbMainAxisSize,
        color: widget.scrollThumb == null ? Colors.grey.withOpacity(0.8) : null,
        child: widget.scrollThumb,
      ),
    );
  }

  Widget animatedFade({
    Widget child,
    bool isAlwaysVisible,
  }) {
    return AnimatedOpacity(
      duration: widget.thumbFadeDuration ?? const Duration(milliseconds: 200),
      opacity: isAlwaysVisible
          ? 1.0
          : isThumbNeeded
              ? 1.0
              : 0.0,
      child: child,
    );
  }
}
