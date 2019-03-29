import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {

  const CustomTextInput({Key key, this.iconPath = '', this.hintText = '', this.keyBoardType = 'text', this.onChange}) : super(key: key);

  final iconPath;

  final hintText;

  final keyBoardType;

  final onChange;

  @override
  Widget build(BuildContext context) {
    TextInputType type = TextInputType.text;
    List<TextInputFormatter> inputFormatter = [];
    if (this.keyBoardType == 'phone') {
      inputFormatter.add(LengthLimitingTextInputFormatter(11));
      inputFormatter.add(BlacklistingTextInputFormatter(new RegExp("[^0-9]")));
    } else {
      inputFormatter.add(LengthLimitingTextInputFormatter(20));
    }
    bool obscureText = false;
    if (this.keyBoardType == 'phone') {
      type = TextInputType.number;
    } else if (this.keyBoardType == 'password') {
      type = TextInputType.text;
      obscureText = true;
    }
    return new Container(
      height: 40,
      margin: new EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: new TextField(
        onChanged: this.onChange,
        inputFormatters: inputFormatter,
        style: TextStyle(
            color: Color(0xff747c8c)
        ),
        cursorColor: Color(0xffe23a55),
        cursorWidth: 2,
        keyboardType: type,
        obscureText: obscureText,
        maxLength: null,
        maxLines: 1,
        decoration: new InputDecoration(
          hintText: this.hintText,
          hintStyle: new TextStyle(color: Color(0xff333333), fontSize: 14),
          border: InputBorder.none,
          prefixIcon: new Image.asset(this.iconPath, height: 16, width: 16,),
          helperStyle: null,
        ),
      ),
    );
  }
}
