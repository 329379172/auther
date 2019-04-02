
import 'dart:convert';

import 'package:otp/otp.dart';
import 'beans.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GetAuthList {
  final List<AuthData> _authList;
  GetAuthList(this._authList);
  get authList => _authList;
}


class InsertAuthData {
  final AuthData _authData;
  InsertAuthData(this._authData);
  get authData => _authData;
}

class DeleteAuthData {
  final int _index;
  DeleteAuthData(this._index);
  get index => _index;
}


class UpdateAuthList {

}


class LoginAction {
  String username;
  String password;
  LoginAction(this.username, this.password);
}

class AccessTokenAction {
  final String _token;
  get token => _token;
  AccessTokenAction(this._token);
}

class UpdateAuthDataAction {
  final List<AuthData> _authDataList;
  get authDataList => _authDataList;
  UpdateAuthDataAction(this._authDataList);
}

class LogoutAction {
}

class AppData {

  List<AuthData> authList;

  String accessToken;

  AppData({this.authList, this.accessToken});

  static initStore () async {
    List<AuthData> list = new List();
    //for(int i = 0; i < 100; i++) {
    //  list.add(new AuthData("ALJV23R4MGFM36UHXPXUXWHGSC5L2NMJ", "www.baidu${i}.com", "${i}"));
    //}
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppData appData = new AppData();
    if (prefs.get("data") != null) {
      appData.authList = json.decode(prefs.get("data"));
    } else {
      appData.authList = list;
    }
    appData.accessToken = prefs.get("token");
    return appData;
  }
}

AppData reducer(AppData appData, dynamic action) {
  if (action is GetAuthList) {
    appData..authList = action.authList;
    return appData;
  } else if (action is UpdateAuthList) {
    //print("update auth List");
    //List<AuthData> list = new List();
    //for(int i = 0; i < 100; i++) {
    //  list.add(new AuthData("ALJV23R4MGFM36UHXPXUXWHGSC5L2NMJ", "www.baidu${i}.com", OTP.generateTOTPCode("ALJV23R4MGFM36UHXPXUXWHGSC5L2NMJ", DateTime.now().millisecondsSinceEpoch).toString()));
    //}
    if (appData.authList == null || appData.authList.length == 0 || OTP.generateTOTPCode(appData.authList[0].key, DateTime.now().millisecondsSinceEpoch).toString() == appData.authList[0].code) {
      //print('不需要更新code!');
      return appData;
    }
    appData.authList.forEach((item) {
      print(item.key);
      item.code = OTP.generateTOTPCode(item.key, DateTime.now().millisecondsSinceEpoch).toString(); 
      if (item.code.length < 6) {
        item.code = new List.filled(6 - item.code.length, '0').join('') + item.code;
      }
    });
    return appData;
  } else if (action is AccessTokenAction) {
    print(action);
    return appData..accessToken = action.token;
  } else if (action is UpdateAuthDataAction) {
    return appData..authList = action.authDataList;
  } else if (action is InsertAuthData) {
    if (appData.authList == null) {
      appData.authList = new List();
    }
    appData.authList.insert(0, action.authData);
    return appData;
  } else if (action is DeleteAuthData) {
    appData.authList.removeAt(action.index);
    return appData;
  } else if (action is LogoutAction) {
    appData.accessToken = null;
    return appData;
  } else {
    return appData;
  }
}