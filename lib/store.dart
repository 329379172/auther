import 'dart:convert';

import 'package:auther/beans.dart';
import 'package:redux/redux.dart';
import 'reducer.dart';
import 'package:shared_preferences/shared_preferences.dart';


Store<AppData> createStore() {
  Store<AppData> store = new Store<AppData>(reducer, initialState: new AppData());
  SharedPreferences.getInstance().then((prefs) {
    if (prefs.get("data") != null) {
      store.state.authList = (json.decode(prefs.get("data")) as List<dynamic>).map((m) => new AuthData.fromJson(m)).toList();
    } else {
      store.state.authList = new List();
    }
    if (prefs.get("token") != null) {
      store.state.accessToken = prefs.get("token");
    }
  });
  SharedPreferences prefs;
  store.onChange.listen((appData) async {
    prefs = await SharedPreferences.getInstance();
    if (appData.authList != null) {
      prefs.setString("data", json.encode(appData.authList));
    }
    prefs.setString("token", appData.accessToken);
  });
  return store;
}

final store = createStore();