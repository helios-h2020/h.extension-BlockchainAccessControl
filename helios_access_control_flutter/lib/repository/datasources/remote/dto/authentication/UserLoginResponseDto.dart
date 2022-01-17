import 'package:helios_access_control_ui/model/Authentication.dart';

class UserLoginResponseDto {
  UserLoginResponseDto({
    this.content,
  });

  String content;

  factory UserLoginResponseDto.fromJson(Map<String, dynamic> json) => UserLoginResponseDto(
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
      };

  UserLoginResponse toModel() {
    return UserLoginResponse(userToken: this.content);
  }
}
