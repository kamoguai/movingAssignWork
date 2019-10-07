import 'package:flutter/material.dart';

///
///提供tool bar用的按鈕
///Date: 2019-03-11
///
class MyFlatButton extends StatelessWidget {
  final String text;

  final Color color;

  final Color textColor;

  final VoidCallback onPress;

  final double fontSize;
  final int maxLines;

  final MainAxisAlignment mainAxisAlignment;

  final EdgeInsets padding;

  final ShapeBorder shape;

  MyFlatButton(
      {Key key, this.text, this.color, this.textColor, this.onPress, this.fontSize = 20.0, this.mainAxisAlignment = MainAxisAlignment.center, this.maxLines = 1, this.padding, this.shape})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
        shape: shape,
        padding: padding,
        textColor: textColor,
        color: color,
        child: new Flex(
          mainAxisAlignment: mainAxisAlignment,
          direction: Axis.horizontal,
          children: <Widget>[new Text(text, style: new TextStyle(fontSize: fontSize), maxLines: maxLines, overflow:TextOverflow.ellipsis)],
        ),
        onPressed: () {
          this.onPress?.call();
        });
  }
}
