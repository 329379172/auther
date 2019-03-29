import 'package:json_annotation/json_annotation.dart';

part 'beans.g.dart';

@JsonSerializable()
class ResultBean {

  @JsonKey(name: "code")
  int code;

  @JsonKey(name: "message")
  String message;

  ResultBean({this.code, this.message});

  factory ResultBean.fromJson(Map<String, dynamic> srcJson) => _$ResultBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResultBeanToJson(this);

}

@JsonSerializable()
class LoginResultBean extends ResultBean {

  @JsonKey(name: "data")
  String accessToken;

  LoginResultBean(this.accessToken);

  factory LoginResultBean.fromJson(Map<String, dynamic> srcJson) => _$LoginResultBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginResultBeanToJson(this);
}


@JsonSerializable()
class AuthDataResultBean extends ResultBean {

  @JsonKey(name: "data")
  List<AuthData> data;

  AuthDataResultBean(this.data);

  factory AuthDataResultBean.fromJson(Map<String, dynamic> srcJson) => _$AuthDataResultBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthDataResultBeanToJson(this);
}

@JsonSerializable()
class AuthData {

  @JsonKey(name: "key")
  String key;

  @JsonKey(name: "remark")
  String remark;

  @JsonKey(name: "code")
  String code;

  @JsonKey(name: "issuer")
  String issuer;

  AuthData(this.key, this.remark, this.code, this.issuer);

  factory AuthData.fromJson(Map<String, dynamic> srcJson) => _$AuthDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AuthDataToJson(this);

}