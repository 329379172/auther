// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beans.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultBean _$ResultBeanFromJson(Map<String, dynamic> json) {
  return ResultBean(
      code: json['code'] as int, message: json['message'] as String);
}

Map<String, dynamic> _$ResultBeanToJson(ResultBean instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};

LoginResultBean _$LoginResultBeanFromJson(Map<String, dynamic> json) {
  return LoginResultBean(json['data'] as String)
    ..code = json['code'] as int
    ..message = json['message'] as String;
}

Map<String, dynamic> _$LoginResultBeanToJson(LoginResultBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.accessToken
    };

AuthDataResultBean _$AuthDataResultBeanFromJson(Map<String, dynamic> json) {
  return AuthDataResultBean((json['data'] as List)
      ?.map((e) =>
          e == null ? null : AuthData.fromJson(e as Map<String, dynamic>))
      ?.toList())
    ..code = json['code'] as int
    ..message = json['message'] as String;
}

Map<String, dynamic> _$AuthDataResultBeanToJson(AuthDataResultBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data
    };

AuthData _$AuthDataFromJson(Map<String, dynamic> json) {
  return AuthData(json['key'] as String, json['remark'] as String,
      json['code'] as String, json['issuer'] as String);
}

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
      'key': instance.key,
      'remark': instance.remark,
      'code': instance.code,
      'issuer': instance.issuer
    };
