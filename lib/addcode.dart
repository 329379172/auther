import 'package:auther/beans.dart';
import 'package:auther/reducer.dart';
import 'package:auther/store.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp/otp.dart';

class AddAuthDataPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new AddAuthDataPageState();
  }
}

class AddAuthDataPageState extends State<AddAuthDataPage> {

  String username;

  String secert;

  onSubmit () {
    if (username == null) {
      Fluttertoast.showToast(
            msg: '请输入帐号信息', timeInSecForIos: 1, gravity: ToastGravity.CENTER);
        return;
    }
    if (secert == null || secert.length != 16 || !secert.contains(new RegExp(r'\w{16}'))) {
     Fluttertoast.showToast(
            msg: '密钥格式有误', timeInSecForIos: 1, gravity: ToastGravity.CENTER);
        return; 
    }
    store.dispatch(InsertAuthData(new AuthData(secert, username, '000000', '')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('手动输入验证码'),
          actions: <Widget>[
            new InkWell(
                onTap: onSubmit,
                child: new Container(
                  width: 50,
                  child: new Center(child: new Icon(Icons.check)),
            )),
          ],
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: '帐号',
                  helperText: '请输入帐号',
                  hintText: 'linfeiyang@fastqiu.com'
                ),
                autofocus: false,
                onChanged: (value) { this.username = value;},
              ),
              new TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  labelText: '密钥',
                  helperText: '请输入密钥',
                  hintText: 'abcd efgh ijkl mnop'
                ),
                autofocus: false,
                onChanged: (value) { this.secert = value; },
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
