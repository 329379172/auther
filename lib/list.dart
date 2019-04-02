import 'dart:async';

import 'package:auther/api.dart';
import 'package:auther/beans.dart';
import 'package:auther/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'reducer.dart';
import 'store.dart';
import 'addcode.dart';

class Auther extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return new AutherState();
  }
}

class AutherState extends State<Auther> {
  Timer _countdownTimer;

  AutherState() {
    _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (mounted) {
        store.dispatch(UpdateAuthList());
      }
    });
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      print(qrResult);
      Uri uri = Uri.parse(qrResult);
      if (uri == null) {
        Fluttertoast.showToast(
            msg: '错误的地址!', timeInSecForIos: 1, gravity: ToastGravity.CENTER);
        return;
      }
      if (uri.scheme != 'otpauth') {
        Fluttertoast.showToast(
            msg: '错误的地址!', timeInSecForIos: 1, gravity: ToastGravity.CENTER);
        return;
      }
      String secret = uri.queryParameters['secret'];
      List<String> paths = uri.path.split(":");
      String remark = '';
      if (paths != null || paths.length > 0) {
        remark = paths[1];
      }
      //String scheme = uri.scheme;
      String issuer = uri.queryParameters['issuer'];
      print(issuer);
      print(secret);
      print(uri.pathSegments.join(","));
      print(uri.path.split(":").join(","));
      print(uri.scheme);
      store.dispatch(new InsertAuthData(new AuthData(
          secret,
          remark,
          '000000',
          issuer)));
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        Fluttertoast.showToast(
            msg: '没有获取到权限!', timeInSecForIos: 1, gravity: ToastGravity.CENTER);
      } else {
        Fluttertoast.showToast(
            msg: '未知异常!', timeInSecForIos: 1, gravity: ToastGravity.CENTER);
      }
    }
  }

  logout() {
    store.dispatch(new LogoutAction());
  }

  deleteData(int index) {
    print('delete $index');
    store.dispatch(new DeleteAuthData(index));
  }

  uploadData() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
                title: new Text("上传确认"),
                content: new Text("上传后将覆盖服务器数据！"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("否"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("是"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Response<Map<String, dynamic>> res = await api_upload();
                      if (res.statusCode != 200) {
                        Fluttertoast.showToast(
                            msg: "服务器傲娇了",
                            timeInSecForIos: 1,
                            gravity: ToastGravity.CENTER);
                      } else {
                        ResultBean resultBean = ResultBean.fromJson(res.data);
                        if (resultBean.code == 200) {
                          Fluttertoast.showToast(
                              msg: "上传成功",
                              timeInSecForIos: 1,
                              gravity: ToastGravity.CENTER);
                        } else {
                          Fluttertoast.showToast(
                              msg: "上传失败",
                              timeInSecForIos: 1,
                              gravity: ToastGravity.CENTER);
                        }
                      }
                    },
                  )
                ]));
  }

  asyncData() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
                title: new Text("下载确认"),
                content: new Text("下载后将覆盖本地数据！"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("否"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("是"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Response<Map<String, dynamic>> res = await api_async();
                      if (res.statusCode != 200) {
                        Fluttertoast.showToast(
                            msg: "服务器傲娇了",
                            timeInSecForIos: 1,
                            gravity: ToastGravity.CENTER);
                      } else {
                        AuthDataResultBean resultBean =
                            AuthDataResultBean.fromJson(res.data);
                        if (resultBean.code == 200) {
                          List<AuthData> data = resultBean.data;
                          //print(data);
                          store.dispatch(UpdateAuthDataAction(data));
                          Fluttertoast.showToast(
                              msg: "下载成功",
                              timeInSecForIos: 1,
                              gravity: ToastGravity.CENTER);
                        } else if (resultBean.code == 401) {
                          Fluttertoast.showToast(
                              msg: "请重新登录",
                              timeInSecForIos: 1,
                              gravity: ToastGravity.CENTER);
                          store.dispatch(new LogoutAction());
                        } else {
                          Fluttertoast.showToast(
                              msg: "下载失败, ${resultBean.message}",
                              timeInSecForIos: 1,
                              gravity: ToastGravity.CENTER);
                        }
                      }
                    },
                  )
                ]));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = new TextStyle(fontSize: 48, color: Colors.blueAccent);
    return new StoreProvider<AppData>(
        store: store,
        child: new StoreConnector<AppData, AppData>(
            builder: (context, state) {
              return new Scaffold(
                  drawer: new Drawer(
                    child: new ListView(
                      children: <Widget>[
                        new UserAccountsDrawerHeader(
                          accountName: Text("小薇识花"),
                          accountEmail: Text("flutter@gmail.com"),
                          currentAccountPicture: new GestureDetector(
                            child: new CircleAvatar(
                              backgroundImage: new ExactAssetImage("images/avatar_bg.jpg"),
                            ),
                          )
                        ),
                        new ListTile(
                          title: new Text(state.accessToken != null ? "注销" : "登录"),
                          leading: new Icon(Icons.person),
                          onTap: () {
                            if (state.accessToken != null) {
                              this.logout();
                            } else {
                             Navigator.pushReplacement(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new Login())); 
                            }
                          },
                        ),
                        new Divider(),
                        new ListTile(
                          title: new Text("服务条款"),
                          leading: new Icon(Icons.announcement),
                        ),
                        new ListTile(
                          title: new Text("关于我们"),
                          leading: new Icon(Icons.people),
                        ),
                      ],
                    )
                  ),
                  appBar: new AppBar(
                    title: new Text("Auther"),
                    leading: new InkWell(
                      child: new Icon(Icons.add),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new ListTile(
                                    leading: new Icon(Icons.photo_camera),
                                    title: new Text("扫描条形码"),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      _scanQR();
                                    },
                                  ),
                                  new ListTile(
                                    leading: new Icon(Icons.edit),
                                    title: new Text("手动输入验证码"),
                                    onTap: () async {
                                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new AddAuthDataPage()));
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    actions: <Widget>[
                      state.accessToken != null
                          ? new Row(
                              children: <Widget>[
                                new InkWell(
                                    child: new Icon(Icons.cloud_download),
                                    onTap: () {
                                      asyncData();
                                    }),
                                new Padding(
                                    padding: new EdgeInsets.only(right: 10)),
                                new InkWell(
                                    child: new Icon(Icons.cloud_upload),
                                    onTap: () {
                                      uploadData();
                                    }),
                                new Padding(
                                    padding: new EdgeInsets.only(right: 10)),
                              ],
                            )
                          : new InkWell(
                              child: new Container(child: new Center(child: new Text("登录", style: new TextStyle(fontSize: 16))), width: 40),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new Login()));
                              }),
                    ],
                  ),
                  body: new ListView.builder(
                    itemCount:
                        state.authList == null ? 0 : state.authList.length,
                    itemBuilder: (BuildContext context, int i) {
                      AuthData authData = state.authList[i];
                      return new Slidable(
                        delegate: new SlidableDrawerDelegate(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          new IconSlideAction(
                            caption: '删除',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {deleteData(i);}
                          )
                        ],
                        key: new Key(authData.code + i.toString()),
                        child: new Container(
                          padding: new EdgeInsets.all(5),
                            decoration: new BoxDecoration(
                              border: new Border(bottom: new BorderSide(color: Color(0xffd9d9d9), width: 0.5 ))
                            ),
                            //height: 100,
                            //color: Colors.white,
                            child: new ListTile(
                              title: new Row(
                                children: <Widget>[
                                  new Expanded(
                                      child: new Row(
                                        children: <Widget>[
                                          new Text(authData.code.substring(0, 3),style: textStyle),
                                          new Padding(padding: new EdgeInsets.only(left: 10)),
                                          new Text(authData.code.substring(3, 6),style: textStyle),
                                        ],
                                      )),
                                  new Container(
                                      child: new Text(
                                          (DateTime.now().second > 30
                                                  ? 60 - DateTime.now().second
                                                  : 30 - DateTime.now().second)
                                              .toString()),
                                      alignment: Alignment.center,
                                      width: 100)
                                ],
                              ),
                              subtitle: new Text(
                                  authData.remark != null
                                      ? authData.remark
                                      : 'no name'),
                            ),
                            //margin: new EdgeInsets.fromLTRB(0, 10, 0, 10),
                      ));
                    }
                  ));
            },
            converter: (store) => store.state));
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }
}
