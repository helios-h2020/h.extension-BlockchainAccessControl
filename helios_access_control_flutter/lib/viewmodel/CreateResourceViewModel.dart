import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/model/Group.dart';
import 'package:helios_access_control_ui/model/Resource.dart';
import 'package:helios_access_control_ui/navigation/AppNavigator.dart';

class CreateResourceViewModel extends GetxController {
  var isLoading = false.obs;
  var resourceCreated = false.obs;
  var currentContent = Content().obs;
  var hasAccess = false.obs;
  var currentResource = Resource().obs;
  var currentGroupLabel = "".obs;
  var accessType = AccessType.INDIVIDUAL.obs;
  var groups = <String, String>{}.obs;
  var groupsLoading = false.obs;

  Map<String, String> groupsMap = {};
  String currentGroupId = "";

  final AppNavigator navigator;

  CreateResourceViewModel(this.navigator);

  void createResource(UploadResource uploadResource) async {
    bool success = false;
    isLoading.value = true;

    uploadResource.accessType = accessType.value;
    if (accessType.value == AccessType.GROUP) {
      uploadResource.groupId = groupsMap.entries
          .firstWhere((element) => element.value == currentGroupLabel.value)
          .key;
    } else {
      uploadResource.groupId = "";
    }
    success = await DI.heliosRepository.createResource(uploadResource);
    resourceCreated.value = success;
    if (success) {
      await navigator.showCreateResourceSuccessful();
      navigator.back(reload: true);
    } else {
      await navigator.showCreateResourceFailed();
      navigator.back(reload: false);
    }
    isLoading.value = false;
  }

  Future<void> onAccessTypeChanged(AccessType accessType) async {
    this.accessType.value = accessType;
    currentGroupLabel.value = "";
    if (accessType == AccessType.GROUP) {
      groupsLoading.value = true;
      List<Group> groupList = await DI.heliosRepository.getAllGroups();
      groupsMap.clear();
      for (Group group in groupList) {
        groupsMap.putIfAbsent(group.id, () => group.uniqueId);
      }
      groups.assignAll(groupsMap);
      groupsLoading.value = false;
    } else {
      groups.clear();
    }
  }

  void onGroupChanged(String groupLabel) {
    currentGroupLabel.value = groupLabel;
  }
}
