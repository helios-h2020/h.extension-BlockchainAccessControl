import 'dart:convert';

import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/model/Notifications.dart';

List<GetAccessRequestResponseDto> getAccessRequestResponseDtoFromJson(
        String str) =>
    List<GetAccessRequestResponseDto>.from(
        json.decode(str).map((x) => GetAccessRequestResponseDto.fromJson(x)));

String getAccessRequestResponseDtoToJson(
        List<GetAccessRequestResponseDto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAccessRequestResponseDto {
  GetAccessRequestResponseDto({
    this.request,
    this.resource,
    this.isOwner,
  });

  RequestDto request;
  ResourceDto resource;
  bool isOwner;

  factory GetAccessRequestResponseDto.fromJson(Map<String, dynamic> json) =>
      GetAccessRequestResponseDto(
        request: RequestDto.fromJson(json["request"]),
        resource: ResourceDto.fromJson(json["resource"]),
        isOwner: json["isOwner"],
      );

  Map<String, dynamic> toJson() => {
        "request": request.toJson(),
        "resource": resource.toJson(),
        "isOwner": isOwner,
      };

  AppNotification toModel() {
    NotificationType notificationType =
        _getNotificationType(resource.accessType);
    return AppNotification(
        id: request.id,
        type: notificationType,
        title: resource.label,
        resourceId: notificationType == NotificationType.MEMBERSHIP_APPLICATION
            ? resource.groupId
            : resource.id,
        requesterId: request.requesterId,
        currentStatus: _getCurrentStatus(request.status),
        creationTime: DateTime.fromMillisecondsSinceEpoch(request.datetime),
        actionsEnabled: isOwner);
  }

  NotificationStatus _getCurrentStatus(String statusAsString) {
    switch (statusAsString) {
      case "PENDING":
        return NotificationStatus.PENDING;
        break;
      case "APPROVED":
        return NotificationStatus.APPROVED;
        break;
    }
    return NotificationStatus.PENDING;
  }

  _getNotificationType(String accessTypeAsString) {
    switch (accessTypeAsString) {
      case "INDIVIDUAL":
        return NotificationType.ACCESS_REQUEST;
        break;
      case "GROUP":
        return NotificationType.MEMBERSHIP_APPLICATION;
        break;
    }
    return NotificationType.ACCESS_REQUEST;
  }
}

class RequestDto {
  RequestDto({
    this.id,
    this.datetime,
    this.status,
    this.requesterId,
  });

  int id;
  int datetime;
  String status;
  String requesterId;

  factory RequestDto.fromJson(Map<String, dynamic> json) => RequestDto(
        id: json["id"],
        datetime: json["datetime"],
        status: json["status"],
        requesterId: json["requesterId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "datetime": datetime,
        "status": status,
        "requesterId": requesterId,
      };
}

class ResourceDto {
  ResourceDto({
    this.id,
    this.label,
    this.type,
    this.accessType,
    this.groupId,
  });

  String id;
  String label;
  String type;
  String accessType;
  String groupId;

  factory ResourceDto.fromJson(Map<String, dynamic> json) => ResourceDto(
      id: json["id"],
      label: json["label"],
      type: json["type"],
      accessType: json["accessType"],
      groupId: json["groupId"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "type": type,
        "accessType": accessType,
        "groupId": groupId
      };
}
