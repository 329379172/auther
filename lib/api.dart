import 'dart:convert';
import 'dart:io';
import 'package:auther/store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

const methodChannel = const MethodChannel('com.longdai/LongdaiMobile');
const currentVersion = '3.0.3';

Dio dio = new Dio(new Options(
  baseUrl: "https://auth.fastqiu.com",
  connectTimeout: 5000,
  receiveTimeout: 5000,
  contentType: ContentType.parse("application/json"),
));


Future<Response<Map<String, dynamic>>> customRequest(String path, dynamic data) async {
  print('path=$path');
  try {
    if (data == null) {
      return dio.post(path);
    } else {
      return dio.post(path, data: data);
    }
  } catch (ex) {
    Fluttertoast.showToast(
      msg: '服务器异常',
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1
    );
  }
  return null;
}

Future<Response<Map<String, dynamic>>> api_login(String username, String password) async {
  return customRequest('/login', {"username": username, "password": password});
}

Future<Response<Map<String, dynamic>>> api_async() async {
  return customRequest('/async?token=${store.state.accessToken}', null);
}

Future<Response<Map<String, dynamic>>> api_upload() async {
  return customRequest('/upload?token=${store.state.accessToken}', json.encode(store.state.authList));
}