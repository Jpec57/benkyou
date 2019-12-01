import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
//todo make it work depending on shake state
class ShakeAnimation extends StatefulWidget {
  final Widget child;

  const ShakeAnimation({Key key, @required this.child}) : super(key: key);

  @override
  ShakeAnimationState createState() => ShakeAnimationState();
}

class ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  bool shake;

  void setShake(bool shouldShake){
    if (shake){
      print('activate');
      animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
      )..addListener(() => setState(() {}));

      animation = Tween<double>(
        begin: 50.0,
      ).animate(animationController);

      animationController.repeat();
    }
    setState(() {
      shake = shouldShake;
    });
    print(shake);
  }

  @override
  void initState() {
    super.initState();
    shake = false;
    print('init');
  }

  Vector3 _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0);
    return Vector3(offset * 3, offset * 0.1, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    if (!shake){
      print('not shake');
      return widget.child;
    }
    print('shake');
    return Transform(
      transform: Matrix4.translation(_shake()),
      child: widget.child,
    );
  }
}