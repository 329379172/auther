import 'package:auther/reducer.dart';
import 'package:auther/store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'input.dart';
import 'api.dart';
import 'beans.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginParams {
  String username;

  String password;
}

class Login extends StatefulWidget {

  //LoginParams loginParams = new LoginParams();

  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }

}

class LoginState extends State<Login> {

  String username;

  String password;

  login(BuildContext context) async {
    print(username);
    print(password);

    Response<Map<String, dynamic>> res = await api_login(username, password);
    if (res.statusCode == 200) {
      LoginResultBean resultBean = LoginResultBean.fromJson(res.data);
      if (resultBean.code == 200 && resultBean.accessToken != null) {
        print("token=${resultBean.accessToken}");
        store.dispatch(AccessTokenAction(resultBean.accessToken));
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
            msg: "登录失败",
            timeInSecForIos: 1
        );
        print("登录失败");
      }
    } else {
      Fluttertoast.showToast(
          msg: "服务器异常",
          timeInSecForIos: 1
      );
      print("服务器异常");
    }
  }

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(title: new Text("登录"),),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new CustomTextInput(
                hintText: '请输入用户名',
                iconPath: 'images/denglu_shouji.png',
                keyBoardType: 'phone',
                onChange: (value) {
                  print("value=${value}");
                  username = value;
                },
              ),
              new CustomTextInput(
                hintText: '请输入密码',
                iconPath: 'images/denglu_mima.png',
                keyBoardType: 'password',
                onChange: (value) {
                  password = value;
                },
              ),
              new FlatButton(onPressed: (){this.login(context);}, child: new Text("登录")),
            ],
          ),
        ),
      );
  }
}