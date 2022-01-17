import 'package:flutter/cupertino.dart';
import 'package:helios_access_control_ui/di/DI.dart';

enum ContentType { IMAGE, DOCUMENT, VIDEO }
enum AccessType { INDIVIDUAL, GROUP }

extension AccessTypeDescription on AccessType {
  String getDescription() {
    String description = "";
    switch (this) {
      case AccessType.INDIVIDUAL:
        description = "Individual";
        break;
      case AccessType.GROUP:
        description = "Group";
        break;
    }
    return description;
  }
}

class Content {
  final ContentType type;
  final String title;
  final String id;
  final AccessType accessType;
  final String groupId;

  Content({this.type, this.title, this.id, this.accessType, this.groupId});

  Color getContentColor() {
    switch (this.type) {
      case ContentType.IMAGE:
        return DI.homeImageColor;
      case ContentType.DOCUMENT:
        return DI.homeDocumentColor;
      case ContentType.VIDEO:
        return DI.homeVideoColor;
      default:
        return DI.homeVideoColor;
    }
  }

  String getContentIcon() {
    switch (this.type) {
      case ContentType.IMAGE:
        return "assets/icon/ic_image.svg";
      case ContentType.DOCUMENT:
        return "assets/icon/ic_doument.svg";
      case ContentType.VIDEO:
        return "assets/icon/ic_video.svg";
      default:
        return "assets/icon/ic_video.svg";
    }
  }

  String get requestAccessId {
    String requestAccessId = "";
    switch (accessType) {
      case AccessType.INDIVIDUAL:
        requestAccessId = id;
        break;
      case AccessType.GROUP:
        requestAccessId = groupId;
        break;
    }
    return requestAccessId;
  }
}
