import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/model/Resource.dart';
import 'package:helios_access_control_ui/navigation/AppNavigator.dart';
import 'package:open_file/open_file.dart';

class DetailContentViewModel extends GetxController {
  var isResourceLoading = false.obs;
  var requestAccessInProgress = false.obs;
  var accessRequested = false.obs;
  var currentContent = Content().obs;
  var hasAccess = true.obs;

  String _localPath;

  final AppNavigator appNavigator;

  DetailContentViewModel(this.appNavigator);

  void loadContent(Content content) async {
    isResourceLoading.value = true;
    currentContent.value = content;
    hasAccess.value = true;
    requestAccessInProgress.value = false;
    accessRequested.value = false;
    Resource resource = await DI.heliosRepository.getResource(content);
    if (resource.isAccessible()) {
      _localPath = resource.localPath;
       hasAccess.value = true;
    } else {
      hasAccess.value = false;
    }
    isResourceLoading.value = false;
  }

  void onAccessRequested() async {
    bool success = false;
    requestAccessInProgress.value = true;
    if (!hasAccess.value) {
      success = await DI.heliosRepository.requestAccess(currentContent.value);
    } else {
      success = true;
    }
    accessRequested.value = success;
    if (success) {
      appNavigator.showRequestAccessSuccessful();
    } else {
      appNavigator.showRequestAccessFailed();
    }
    requestAccessInProgress.value = false;
  }

  String requestText() {
    switch (currentContent.value.accessType) {
      case AccessType.INDIVIDUAL:
        return "REQUEST ACCESS";
        break;
      case AccessType.GROUP:
        return "APPLY FOR MEMBERSHIP";
      default:
        return "REQUEST ACCESS";
    }
  }

  void onNoPermissionsDetected() {
    hasAccess.value = false;
  }

  Future<void> openResource() async {
    await OpenFile.open(_localPath);
  }
}
