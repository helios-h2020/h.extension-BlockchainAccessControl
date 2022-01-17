import 'package:helios_access_control_ui/model/Group.dart';

class CreateGroupRequestDto {
  CreateGroupRequestDto({
    this.label,
  });

  String label;

  factory CreateGroupRequestDto.fromJson(Map<String, dynamic> json) =>
      CreateGroupRequestDto(
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
      };

  static CreateGroupRequestDto fromModel(Group group) {
    return CreateGroupRequestDto(
      label: group.label,
    );
  }
}
