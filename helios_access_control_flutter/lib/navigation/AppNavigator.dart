import 'package:get/get.dart';
import 'package:helios_access_control_ui/screen/CreateResourceScreen.dart';
import 'package:helios_access_control_ui/utils/DialogUtils.dart';

class AppNavigator {

  Future<bool> goToCreateResourceScreen() {
    return Get.to(CreateResourceScreen());
  }

  void showRequestAccessSuccessful() {
    DialogUtils.showConfirmDialog(
        title: "Request sent",
        message:
            "Your request has been sent successfully. When the content owner approves your request, you will be able to access the content.",
        confirmText: "OK",
        confirmAction: () => Get.back());
  }

  void showRequestAccessFailed() {
    DialogUtils.showConfirmDialog(
        title: "Request not sent",
        message: "Your request access has been failed.\nPlease try later",
        confirmText: "OK",
        confirmAction: () => Get.back());
  }

  Future<bool> showCreateResourceSuccessful() {
    return DialogUtils.showConfirmDialog(
        title: "Resource created",
        message: "Your resource has been created successfully.",
        confirmText: "OK",
        confirmAction: () => Get.back());
  }

  void showCreateResourceFailed() {
    DialogUtils.showConfirmDialog(
        title: "Resource not created",
        message: "Your resource has not been created.\nPlease try later",
        confirmText: "OK",
        confirmAction: () => Get.back());
  }

  void back({bool reload}) {
    Get.back(result: reload);
  }
}
