[![pub package](https://img.shields.io/pub/v/flexible_scrollbar)](https://pub.dartlang.org/packages/flexible_scrollbar)

# A Flexible Scrollbar for Flutter
A flexible solution for custom scroll bars.

![](https://user-images.githubusercontent.com/46086231/118855133-2355ad00-b8de-11eb-992f-6f3e726ef507.gif)
</br></br>
# Foreword
A package has been designed to allow the creation of complex scroll bars. You can customize the scroll thumb, scroll line and add a label, that is positioned by the center of the scroll thumb by default, but you can customize its position as well. As those three things are created by builders called every time the scroll state is changed, you can add custom animations.

# How to use

The usage is as simple as a built-in Scrollbar, only you can customize it a lot more.

## Install

To install this package simply add the `flexible_scrollbar` to your dependencies in `pubspec.yaml`
```yaml
# pubspec.yaml
dependencies:
  flexible_scrollbar:
```
## Basic usage

To get a scrollbar simply wrap a scrollable widget with `FlexibleScrollbar` and pass a `ScrollController` to both `FlexibleScrollbar` and a scrollable widget:

```dart
FlexibleScrollbar(
     controller: scrollController,
     alwaysVisible: true,
     child: GridView.builder(
```
You will get a defaul scroll thumb and settings:</br>
![](https://user-images.githubusercontent.com/46086231/118859755-433b9f80-b8e3-11eb-952a-236cfe5d277c.png)

But it's very simple and can be made by default means, and we are here to make complex scroll bars so let's see how.

## Customization

For the main customization the `FlexibleScrollbar` widget has three builders: `scrollThumbBuilder`, `scrollLineBuilder` and `scrollLabelBuilder`. Each one of them has a `ScrollbarInfo` as a parameter and rebuild each time any of the fields of the `ScrollbarInfo` model has changed.</br>
</br>
`ScrollbarInfo` model has the following properties:

|  Properties  |   Description   |
|--------------|-----------------|
| `bool isScrolling` | Changes when the user starts/strops the scroll body scrolling. The `isDragging` is not affected by it. |
| `bool isDragging` | Changes when the user starts/strops to drag the scroll thumb. The `isScrolling` is not affected by it. |
| `double thumbMainAxisSize` | Contains the calculated depending on the scroll body size thumb length. |
| `double thumbMainAxisOffset` | Contains the offset in pixels of the scrollthumb from the starting position. |
| `AxisDirection scrollDirection` | Has the scroll body scroll direction in it (`up`/`down`/`left`/`right`) |
</br>
Using those builders you can make custom scrollbars such as the one shown in the example at the beginning. The scroll thumb from the example has been created with the following code:

```dart
scrollThumbBuilder: (ScrollbarInfo info) {
     return AnimatedContainer(
       width: info.isDragging
           ? thumbDragWidth
           : thumbWidth,
       height: info.thumbMainAxisSize,
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(5),
         color: Colors.black.withOpacity(info.isDragging ? 1 : 0.6),
       ),
       duration: animationDuration,
     );
},
```
