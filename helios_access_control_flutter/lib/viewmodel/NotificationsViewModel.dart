import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Notifications.dart';

class NotificationsViewModel extends GetxController {
  var isLoading = false.obs;
  var appNotifications = <AppNotification>[].obs;

  final NotificationStatus notificationStatus;

  NotificationsViewModel(this.notificationStatus);

  @override
  void onReady() {
    super.onReady();
    getNotifications(notificationStatus);
  }

  void getNotifications(NotificationStatus notificationStatus) async {
    isLoading.value = true;
    List<AppNotification> notifications =
        await DI.heliosRepository.getNotifications(notificationStatus);
    appNotifications.assignAll(notifications);
    isLoading.value = false;
  }

  void approveAccessRequest(AppNotification appNotification) async {
    isLoading.value = true;
    await DI.heliosRepository.grantAccessRequest(appNotification);
    getNotifications(notificationStatus);
  }

  void rejectAccessRequest(AppNotification appNotification) async {
    isLoading.value = true;
    await DI.heliosRepository.rejectAccessRequest(appNotification);
    getNotifications(notificationStatus);
  }
}
