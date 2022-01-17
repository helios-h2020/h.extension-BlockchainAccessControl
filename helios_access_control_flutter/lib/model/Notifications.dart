enum NotificationStatus { PENDING, APPROVED }

extension NotificationStatusExtensions on NotificationStatus {
  // ignore: missing_return
  String get asString {
    switch (this) {
      case NotificationStatus.PENDING:
        return "PENDING";
        break;
      case NotificationStatus.APPROVED:
        return "ACCEPTED";
        break;
    }
  }
}

enum NotificationType {
  ACCESS_REQUEST,
  MEMBERSHIP_APPLICATION,
}

extension NotificationTypeExtensions on NotificationType {
  // ignore: missing_return
  String get asString {
    switch (this) {
      case NotificationType.ACCESS_REQUEST:
        return "Access Request";
        break;
      case NotificationType.MEMBERSHIP_APPLICATION:
        return "Membership application";
        break;
    }
  }
}

class AppNotification {
  final int id;
  final NotificationType type;
  final String title;
  final String resourceId;
  final String requesterId;
  final NotificationStatus currentStatus;
  final DateTime creationTime;
  bool actionsEnabled;

  AppNotification({
    this.id,
    this.type,
    this.title,
    this.resourceId,
    this.requesterId,
    this.currentStatus,
    this.creationTime,
    this.actionsEnabled = false,
  });
}
