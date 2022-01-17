import 'package:helios_access_control_ui/model/Authentication.dart';

class UserLoginRequestDto {
  UserLoginRequestDto({
    this.id,
    this.pass,
    this.fcmToken,
  });

  String id;
  String pass;
  String fcmToken;

  factory UserLoginRequestDto.fromJson(Map<String, dynamic> json) => UserLoginRequestDto(
        id: json["id"],
        pass: json["pass"],
        fcmToken: json["fcmToken"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pass": pass,
        "fcmToken": fcmToken
      };

  static UserLoginRequestDto fromModel(UserLoginRequest userLoginRequest) {
    return UserLoginRequestDto(
      id: userLoginRequest.id,
      pass: userLoginRequest.pass,
      fcmToken: userLoginRequest.fcmToken
    );
  }
}
