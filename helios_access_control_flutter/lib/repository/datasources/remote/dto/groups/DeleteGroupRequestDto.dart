class DeleteGroupRequestDto {
  DeleteGroupRequestDto({
    this.groupId,
  });

  String groupId;

  factory DeleteGroupRequestDto.fromJson(Map<String, dynamic> json) =>
      DeleteGroupRequestDto(
        groupId: json["groupId"],
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
      };

  static DeleteGroupRequestDto fromModel(String groupId) {
    return DeleteGroupRequestDto(
      groupId: groupId,
    );
  }
}
