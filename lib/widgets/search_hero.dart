import 'package:flutter/material.dart';

/**
 * @author zcp
 * @date 2019/4/25
 * @Description
 */
class SearchHero extends StatelessWidget {
  const SearchHero({ Key key, this.search, this.onTap, this.width }) : super(key: key);

  final String search;
  final VoidCallback onTap;
  final double width;

  Widget build(BuildContext context) {
    return new SizedBox(
      width: width,
      child: new Hero(
        tag: search,
        child: new Material(
          color: Colors.transparent,
          child: new InkWell(
            onTap: onTap,
            child: Icon(Icons.search,color: Colors.white,),
          ),
        ),
      ),
    );
  }
}