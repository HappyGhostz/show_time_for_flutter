import 'package:flutter/material.dart';
import 'dart:math';
/**
 * @author zcp
 * @date 2019/3/28
 * @Description
 */

class NeedleAnimatePage extends AnimatedWidget{
  NeedleAnimatePage({Key key,
    @required Animation<double> animation,
    this.alignment: FractionalOffset.topCenter,
    this.child,
  }):super(key:key,listenable:animation);

  /// The animation that controls the rotation of the child.
  /// If the current value of the turns animation is v, the child will be
  /// rotated v * 2 * pi radians before being painted.
  Animation<double> get animation => listenable;

  /// The pivot point to rotate around.
  final FractionalOffset alignment;

  /// The widget below this widget in the tree.
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final double turnsValue = animation.value;
    final Matrix4 transform = new Matrix4.rotationZ(turnsValue * pi * 2.0);
    return Transform(transform: transform,
    alignment: alignment,
    child: child,);
  }
}
