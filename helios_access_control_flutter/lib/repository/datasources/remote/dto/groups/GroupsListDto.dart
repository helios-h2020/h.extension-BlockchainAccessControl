import 'package:helios_access_control_ui/model/Group.dart';

class GroupsListDto {
  GroupsListDto({
    this.content,
  });

  List<GroupContentDto> content;

  factory GroupsListDto.fromJson(Map<String, dynamic> json) => GroupsListDto(
        content: List<GroupContentDto>.from(
            json["content"].map((x) => GroupContentDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };

  List<Group> toModel() {
    return content
        .map((dto) => Group(
              id: dto.id,
              label: dto.label,
            ))
        .toList();
  }
}

class GroupContentDto {
  GroupContentDto({
    this.id,
    this.label,
  });

  String id;
  String label;

  factory GroupContentDto.fromJson(Map<String, dynamic> json) =>
      GroupContentDto(
        id: json["id"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
      };
}
