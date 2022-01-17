import 'package:helios_access_control_ui/model/Authentication.dart';

class UserRegisterResponseDto {
  UserRegisterResponseDto({
    this.content,
  });

  String content;

  factory UserRegisterResponseDto.fromJson(Map<String, dynamic> json) => UserRegisterResponseDto(
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
      };

  UserRegisterResponse toModel() {
    return UserRegisterResponse(content: this.content);
  }
}
