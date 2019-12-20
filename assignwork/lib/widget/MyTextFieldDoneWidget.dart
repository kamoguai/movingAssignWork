
import 'package:assignwork/common/style/MyStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
///鍵盤上方添加Done按鈕
///Date: 2019-12-19
class MyTextFieldDoneWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Color(MyColors.hexFromStr('f0f0f2')),
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Text('完成', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
    );
  }
}