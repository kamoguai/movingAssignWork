import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
///輸入框樣式，會判別是ios還是android
///Date: 2019-12-19
class MyTextFieldWidget extends StatefulWidget {

  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final int maxLines;
  final int maxlenght;
  final TextStyle style;
  final String labelText;
  final String hintText;
  final ValueChanged<dynamic> onFieldSubmitted;

  MyTextFieldWidget({Key key, this.controller, this.textInputType, this.textInputAction, this.focusNode, this.maxlenght, this.maxLines, this.style, this.labelText, this.hintText, this.onFieldSubmitted});
  @override
  _MyTextFieldWidgetState createState() => _MyTextFieldWidgetState();
}

class _MyTextFieldWidgetState extends State<MyTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    Widget body;

    if (Platform.isAndroid) {
      body = TextFormField(
        controller: widget.controller,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        maxLines: widget.maxLines,
        maxLength: widget.maxlenght,
        style: widget.style,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2.0),
            borderSide: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid)
          )
        ),
        onFieldSubmitted: widget.onFieldSubmitted
      );
    }
    else {
      body = CupertinoTextField(
        controller: widget.controller,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        maxLength: widget.maxlenght,
        maxLines: widget.maxLines,
        style: widget.style,
        onChanged: widget.onFieldSubmitted,
      );
    }
    return body;
  }
}