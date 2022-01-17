import 'package:helios_access_control_ui/model/Content.dart';

class CreateAccessRequestDto {
  CreateAccessRequestDto({this.resourceId, this.groupId});

  String resourceId;
  String groupId;

  factory CreateAccessRequestDto.fromJson(Map<String, dynamic> json) =>
      CreateAccessRequestDto(
        resourceId: json["resourceId"],
        groupId: json["groupId"],
      );

  Map<String, dynamic> toJson() => {
        "resourceId": resourceId,
        "groupId": groupId,
      };

  static CreateAccessRequestDto fromModel(Content content) {
    return CreateAccessRequestDto(
      resourceId: content.id,
    );
  }
}
