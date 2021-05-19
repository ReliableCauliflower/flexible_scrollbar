[![pub package](https://img.shields.io/pub/v/flexible_scrollbar)](https://pub.dartlang.org/packages/flexible_scrollbar)

# A Flexible Scrollbar for Flutter
A flexible solution for custom scroll bars.

![](https://user-images.githubusercontent.com/46086231/118855133-2355ad00-b8de-11eb-992f-6f3e726ef507.gif)

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
