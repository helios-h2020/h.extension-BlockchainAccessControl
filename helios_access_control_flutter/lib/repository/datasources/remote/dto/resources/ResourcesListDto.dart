import 'dart:io';

import 'package:helios_access_control_ui/model/Content.dart';

class ResourcesListDto {
  ResourcesListDto({
    this.content,
  });

  List<ContentDto> content;

  factory ResourcesListDto.fromJson(Map<String, dynamic> json) =>
      ResourcesListDto(
        content: List<ContentDto>.from(
            json["content"].map((x) => ContentDto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };

  List<Content> toModel() {
    return content
        .map((dto) => Content(
              type: _getContentType(dto),
              id: dto.id,
              title: dto.label,
              accessType: _getAccessType(dto),
              groupId: dto.groupId
            ))
        .toList();
  }

  ContentType _getContentType(ContentDto dto) {
    String typeUpperCase = dto.type.toUpperCase();
    if (_contentTypeMapper.containsKey(typeUpperCase)) {
      return _contentTypeMapper[typeUpperCase];
    } else {
      return null;
    }
  }

  AccessType _getAccessType(ContentDto dto) {
    String accessTypeUppercase = dto.accessType.toUpperCase();
    if (_accessTypeMapper.containsKey(accessTypeUppercase)) {
      return _accessTypeMapper[accessTypeUppercase];
    } else {
      return null;
    }
  }
}

class ContentDto {
  ContentDto({this.id, this.url, this.label, this.type, this.accessType, this.groupId});

  String id;
  String url;
  String label;
  String type;
  String accessType;
  String groupId;

  factory ContentDto.fromJson(Map<String, dynamic> json) => ContentDto(
      id: json["id"],
      url: json["url"],
      label: json["label"],
      type: json["type"],
      accessType: json["accessType"],
      groupId: json["groupId"]
  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "label": label,
        "type": type,
        "accessType": accessType,
        "groupId": groupId
      };
}

const Map<String, ContentType> _contentTypeMapper = {
  "IMAGE": ContentType.IMAGE,
  "VIDEO": ContentType.VIDEO,
  "DOCUMENT": ContentType.DOCUMENT
};

const Map<String, AccessType> _accessTypeMapper = {
  "INDIVIDUAL": AccessType.INDIVIDUAL,
  "GROUP": AccessType.GROUP,
};
