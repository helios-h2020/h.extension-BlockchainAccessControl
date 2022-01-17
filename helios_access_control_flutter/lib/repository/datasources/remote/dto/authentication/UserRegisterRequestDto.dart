import 'package:helios_access_control_ui/model/Authentication.dart';

class UserRegisterRequestDto {
  UserRegisterRequestDto({
    this.id,
    this.pass,
    this.token,
    this.name,
  });

  String id;
  String pass;
  String token;
  String name;

  factory UserRegisterRequestDto.fromJson(Map<String, dynamic> json) => UserRegisterRequestDto(
    id: json["id"],
    pass: json["pass"],
    token: json["token"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pass": pass,
    "token": token,
    "name": name,
  };

  static UserRegisterRequestDto fromModel(UserRegisterRequest userRegisterRequest) {
    return UserRegisterRequestDto(
      id: userRegisterRequest.id,
      pass: userRegisterRequest.pass,
      token: userRegisterRequest.fcmToken,
      name: userRegisterRequest.name
    );
  }
}