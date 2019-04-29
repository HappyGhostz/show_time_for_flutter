import 'package:flutter/material.dart';

/**
 * @author zcp
 * @date 2019/4/12
 * @Description
 */
class RouterAnimationUtils{
  /// 创建一个从左边滑入的平移变换
  /// 跳转过去查看源代码，可以看到有各种各样定义好的变换
  static SlideTransition createTransition(
      Animation<double> animation, Widget child) {
    return new SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(-1.0, 0.0),//offset(dx,dy),dx有值表示在x轴上移动，正负为方向相反；y轴亦然
        end: Offset.zero,
      ).animate(animation),
      child: child, // child is the value returned by pageBuilder
    );
  }
  static ScaleTransition createScaleTransition(
      Animation<double> animation, Widget child) {
    return new ScaleTransition(scale: new Tween<double>(
      begin: 0.0,
      end:1.0,
    ).animate(animation),
    alignment: Alignment.center,child: child,);
  }
}