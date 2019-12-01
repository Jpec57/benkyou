import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class LeftScrollablePhysic extends ScrollPhysics {
  bool isGoingRight = false;

  LeftScrollablePhysic({ScrollPhysics parent}) : super(parent: parent);


  @override
  LeftScrollablePhysic applyTo(ScrollPhysics ancestor) {
    return LeftScrollablePhysic(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    isGoingRight = offset.sign > 0;
    return offset;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
                'The proposed new position, $value, is exactly equal to the current position of the '
                'given ${position.runtimeType}, ${position.pixels}.\n'
                'The applyBoundaryConditions method should only be called when the value is '
                'going to actually change the pixels, otherwise it is redundant.\n'
                'The physics object in question was:\n'
                '  $this\n'
                'The position object in question was:\n'
                '  $position\n');
      }
      return true;
    }());
    if (value < position.pixels && position.pixels <= position.minScrollExtent)
      return value - position.pixels;
    if (position.maxScrollExtent <= position.pixels && position.pixels < value)
      return value - position.pixels;
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels)
      return value - position.minScrollExtent;
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value)
      return value - position.maxScrollExtent;
    if (!isGoingRight) {
      return value - position.pixels;
    }
    return 0.0;
  }
}