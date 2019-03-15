import 'package:flutter/material.dart';
import 'dart:math';

List<String> images = [
  "assets/images/no_data_one.png",
  "assets/images/no_data_two.png",
  "assets/images/no_data_three.png",
  "assets/images/no_data_four.png",
  "assets/images/no_data_five.png",
  "assets/images/no_data_sex.png",
  "assets/images/no_data_seven.png",
  "assets/images/no_data_eight.png",
  "assets/images/no_data_nine.png",
  "assets/images/no_data_ten.png",
];

class ImageUtils {
  static Widget showFadeImageForSize(
      String imageSrc, double height, double width, BoxFit boxFit) {
    if (imageSrc == null||imageSrc=="") {
      return Image.asset(
        getAssetsImage(),
        fit: boxFit,
        height: height,
      );
    } else {
      return FadeInImage.assetNetwork(
        placeholder: getAssetsImage(),
        image: imageSrc,
        width: width,
        height: height,
        fit: boxFit,
      );
    }
  }
  static Widget showFadeImage(
      String imageSrc, BoxFit boxFit) {
    if (imageSrc == null||imageSrc=="") {
      return Image.asset(
        getAssetsImage(),
        fit: boxFit,
      );
    } else {
      return FadeInImage.assetNetwork(
        placeholder: getAssetsImage(),
        image: imageSrc,
        fit: boxFit,
      );
    }
  }

  static Widget showFadeImageForHeight(
      String imageSrc, double height, BoxFit boxFit) {
    var uri = Uri.parse("imageSrc");
    if (imageSrc == null||imageSrc=="") {
      return Image.asset(
        getAssetsImage(),
        fit: boxFit,
        height: height,
      );
    } else {
      return FadeInImage.assetNetwork(
        placeholder: getAssetsImage(),
        image: imageSrc,
        height: height,
        fit: boxFit,
      );
    }
  }
  static Widget showFadeImageForWidth(
      String imageSrc, double width, BoxFit boxFit) {
    var uri = Uri.parse("imageSrc");
    if (imageSrc == null||imageSrc=="") {
      return Image.asset(
        getAssetsImage(),
        fit: boxFit,
        width: width,
      );
    } else {
      return FadeInImage.assetNetwork(
        placeholder: getAssetsImage(),
        image: imageSrc,
        width: width,
        fit: boxFit,
      );
    }
  }
}

String getAssetsImage() {
  var nextInt = Random().nextInt(images.length - 1);
  return images[nextInt];
}
