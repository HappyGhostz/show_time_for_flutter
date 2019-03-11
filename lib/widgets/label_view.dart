import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui show TextStyle;

class LabelViewDecoration extends StatefulWidget {
  final Size size;
  final Color labelColor;
  final Color labelTextColor;
  final labelAlignment;
  final bool useAngle;
  final String labelText;
  final Widget child;

  LabelViewDecoration(
      {@required this.size,
      @required this.child,
      this.labelText = "HOT",
      this.labelColor = Colors.blue,
      this.labelTextColor = Colors.blue,
      this.labelAlignment = LabelAlignment.leftTop,
      this.useAngle = true});

  @override
  State<StatefulWidget> createState() => LabelViewState();
}

class LabelViewState extends State<LabelViewDecoration> {
  var textAngle;
  var textAlignment;
  var offset;
  AlignmentGeometry alignment = AlignmentDirectional.topStart;
  @override
  Widget build(BuildContext context) {
    switch(widget.labelAlignment){
      case LabelAlignment.leftTop:
        alignment = AlignmentDirectional.topStart;
        break;
      case LabelAlignment.leftBottom:
        alignment = AlignmentDirectional.bottomStart;
        break;
      case LabelAlignment.rightTop:
        alignment = AlignmentDirectional.topEnd;
        break;
      case LabelAlignment.rightBottom:
        alignment = AlignmentDirectional.bottomEnd;
        break;

    }
    return Stack(
      alignment: alignment,
      children: <Widget>[
        widget.child,
        Container(
          width: widget.size.width,
          height: widget.size.height,
          child: CustomPaint(
            painter: new LabelViewPainter(
              widget.labelColor,
              widget.labelAlignment,
              widget.useAngle,
              widget.labelText,
              widget.labelTextColor,
            ),
            size: widget.size,
          ),
        )
      ],
    )
      ;
  }
}

class LabelViewPainter extends CustomPainter {
  final int labelAlignment;
  final Color labelColor;
  Paint _paint;
  var useAngle;
  String labelText;
  Color labelTextColor;

  LabelViewPainter(
    this.labelColor,
    this.labelAlignment,
    this.useAngle,
    this.labelText,
    this.labelTextColor,
  ) {
    _paint = new Paint()
      ..color = labelColor
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var drawSize = size.height > size.width ? size.width / 2 : size.height / 2;
    Path path = new Path();
    switch (labelAlignment) {
      case LabelAlignment.leftTop:
        if (!useAngle) {
          path.moveTo(drawSize / 2, 0);
          path.lineTo(0, drawSize / 2);
        }
        path.lineTo(0, drawSize);
        path.lineTo(drawSize, 0);
        break;
      case LabelAlignment.leftBottom:
        path.moveTo(0, size.height - drawSize);

        if (useAngle) {
          path.lineTo(drawSize, size.height);
          path.lineTo(0, size.height);
        } else {
          path.lineTo(0, size.height - drawSize / 2);
          path.lineTo(drawSize / 2, size.height);
          path.lineTo(drawSize, size.height);
        }
        break;
      case LabelAlignment.rightTop:
        path.moveTo(size.width - drawSize, 0);
        if (useAngle) {
          path.lineTo(size.width, 0);
        } else {
          path.lineTo(size.width - drawSize / 2, 0);
          path.lineTo(size.width, drawSize / 2);
        }

        path.lineTo(size.width, drawSize);
        break;
      case LabelAlignment.rightBottom:
        if (useAngle) {
          path.moveTo(size.width, size.height);

          path.lineTo(size.width - drawSize, size.height);
          path.lineTo(size.width, size.height - drawSize);
        } else {
          path.moveTo(size.width - drawSize, size.height);
          path.lineTo(size.width - drawSize / 2, size.height);
          path.lineTo(size.width, size.height - drawSize / 2);
          path.lineTo(size.width, size.height - drawSize);
        }
        break;
      default:
        if (!useAngle) {
          path.moveTo(drawSize / 2, 0);
          path.lineTo(0, drawSize / 2);
        }
        path.lineTo(0, drawSize);
        path.lineTo(drawSize, 0);
        break;
    }
    path.close();
    canvas.drawPath(path, _paint);

    canvas.save();

    //计算字体size
    double minWidth = 0;
    switch(labelAlignment){
      case LabelAlignment.leftTop:
        //旋转画布并平移  代码上是先做平移在旋转操作，反着来
        canvas.translate(0.0, drawSize);
        canvas.rotate(angleToRadian(-45.0));
        if (useAngle) {
          double x = ((drawSize / 2) * (drawSize / 2) / 2);
          minWidth = sqrt(x);
          //方法一：使用drawParagraph绘制文字，Paragraph是ui包内的
          Paragraph paragraph = buildParagraph(labelText, minWidth, drawSize);
          canvas.drawParagraph(paragraph, Offset(0, -drawSize / 2));
        } else {
          double x = ((drawSize / 3) * (drawSize / 3) / 2);
          minWidth = sqrt(x);
          //方法一：使用drawParagraph绘制文字，Paragraph是ui包内的
          Paragraph paragraph = buildParagraph(labelText, minWidth, drawSize / 2);
          canvas.drawParagraph(paragraph, Offset(drawSize / 3, -drawSize / 3));
        }
        break;
      case LabelAlignment.leftBottom:
        canvas.translate(0.0, drawSize);
        canvas.rotate(angleToRadian(45.0));
        if (useAngle) {
          double x = ((drawSize / 2) * (drawSize / 2) / 2);
          minWidth = sqrt(x);
          //方法一：使用drawParagraph绘制文字，Paragraph是ui包内的
          Paragraph paragraph = buildParagraph(labelText, minWidth, drawSize);
          canvas.drawParagraph(paragraph, Offset(0, 0));
        } else {
          double x = ((drawSize / 3) * (drawSize / 3) / 2);
          minWidth = sqrt(x);
          //方法一：使用drawParagraph绘制文字，Paragraph是ui包内的
          Paragraph paragraph = buildParagraph(labelText, minWidth, drawSize / 2);
          canvas.drawParagraph(paragraph, Offset(drawSize / 3, drawSize /27));
        }
        break;
      case LabelAlignment.rightTop:
      //旋转画布并平移  代码上是先做平移在旋转操作，反着来
        canvas.translate(0.0, drawSize);
        canvas.rotate(angleToRadian(45.0));
        if (useAngle) {
          double x = ((drawSize / 2) * (drawSize / 2) / 2);
          minWidth = sqrt(x);
          //方法一：使用drawParagraph绘制文字，Paragraph是ui包内的
          Paragraph paragraph = buildParagraph(labelText, minWidth, drawSize);
          canvas.drawParagraph(paragraph, Offset(drawSize/8,-drawSize*2));
        } else {
          double x = ((drawSize / 3) * (drawSize / 3) / 2);
          minWidth = sqrt(x);
          //方法一：使用drawParagraph绘制文字，Paragraph是ui包内的
          Paragraph paragraph = buildParagraph(labelText, minWidth, drawSize / 2);
          canvas.drawParagraph(paragraph, Offset(drawSize/2 , -drawSize*7/4 ));
        }
        break;
      case LabelAlignment.rightBottom:
      //旋转画布并平移  代码上是先做平移在旋转操作，反着来
        canvas.translate(0.0, drawSize);
        canvas.rotate(angleToRadian(-45.0));
        if (useAngle) {
          double x = ((drawSize / 2) * (drawSize / 2) / 2);
          minWidth = sqrt(x);
          //方法一：使用drawParagraph绘制文字，Paragraph是ui包内的
          Paragraph paragraph = buildParagraph(labelText, minWidth, drawSize);
          canvas.drawParagraph(paragraph, Offset(drawSize*8/5, -drawSize/4));
        } else {
          double x = ((drawSize / 3) * (drawSize / 3) / 2);
          minWidth = sqrt(x);
          //方法一：使用drawParagraph绘制文字，Paragraph是ui包内的
          Paragraph paragraph = buildParagraph(labelText, minWidth, drawSize / 2);
          canvas.drawParagraph(paragraph, Offset(drawSize*2, -drawSize/5));
        }
        break;
      default:

        break;
    }
    //方法二：使用TextPainter来绘制文字
//    TextStyle textStyle = new TextStyle(
//      color: Colors.white,
//      fontSize: minWidth-1,
//      fontWeight: FontWeight.w500,
//    );
//    TextSpan textSpan = new TextSpan(
//      text: "专题",
//      style: textStyle,
//    );
//    TextPainter textPainter = new TextPainter(
//      text: textSpan,
//      textDirection: TextDirection.ltr,
//      textAlign: TextAlign.left
//    );
//    textPainter.layout(minWidth: drawSize*2,maxWidth: drawSize*2);
//    textPainter.paint(canvas, Offset(drawSize/3, -drawSize/2));
    canvas.restore();
  }

//根据文本内容和字体大小等构建一段文本
  Paragraph buildParagraph(String text, double textSize, double constWidth) {
    ParagraphBuilder builder = ParagraphBuilder(
      ParagraphStyle(
        textAlign: TextAlign.right,
        fontSize: textSize,
        fontWeight: FontWeight.normal,
      ),
    );
    builder.pushStyle(ui.TextStyle(color: labelTextColor));
    builder.addText(text);
    ParagraphConstraints constraints = ParagraphConstraints(width: constWidth);
    return builder.build()..layout(constraints);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double angleToRadian(double angle) => angle * (pi / 180.0);

  double radianToAngle(double radian) => radian * (180.0 / pi);
}

class LabelAlignment {
  int labelAlignment;

  LabelAlignment(this.labelAlignment);

  static const leftTop = 0;
  static const leftBottom = 1;
  static const rightTop = 2;
  static const rightBottom = 3;
}
