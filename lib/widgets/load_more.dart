import 'package:flutter/material.dart';

/**
 * @author zcp
 * @date 2019/3/22
 * @Description
 */
class LoadMorePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/load_more.gif",
            width: 120,
            height: 60,
            fit: BoxFit.contain,
          )
        ],
      ),
    );
  }
}