import 'package:flutter/material.dart';

///
///自定義inputField
///
class MyInputWidget extends StatefulWidget {
  final bool obscureText;

  final String hintText;
  final String textTitle;

  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextEditingController controller;

  MyInputWidget({Key key, this.hintText, this.textTitle, this.onChanged,this.textStyle, this.controller, this.obscureText = false}) :super(key: key);
  
  @override
  _MyInputWidgetState createState() => _MyInputWidgetState();
}

class _MyInputWidgetState extends State<MyInputWidget> {

  _MyInputWidgetState(): super();

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      style: widget.textStyle,
      decoration: new InputDecoration(
        hintText: widget.hintText,
        labelText: widget.textTitle,
        filled: true,
        fillColor: Colors.white
      ),
    );
  }
}