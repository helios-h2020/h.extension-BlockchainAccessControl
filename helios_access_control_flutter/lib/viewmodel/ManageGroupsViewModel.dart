import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Group.dart';
import 'package:helios_access_control_ui/repository/Repository.dart';

class ManageGroupsViewModel extends GetxController {
  var isLoading = false.obs;
  var groupName = "".obs;

  var groupsDeleteList = <String, String>{}.obs;
  var currentGroupLabelToDelete = "".obs;
  var deleteGroupLoading = false.obs;

  Map<String, String> groupsMap = {};

  final HeliosRepository heliosRepository;

  ManageGroupsViewModel(this.heliosRepository);

  @override
  void onReady() async {
    super.onReady();
    loadGroups();
  }

  void loadGroups() async {
    deleteGroupLoading.value = true;
    currentGroupLabelToDelete.value = "";
    List<Group> groupList = await DI.heliosRepository.getAllGroups();
    groupsMap.clear();
    for (Group group in groupList) {
      groupsMap.putIfAbsent(group.id, () => group.uniqueId);
    }
    groupsDeleteList.assignAll(groupsMap);
    deleteGroupLoading.value = false;
  }

  void setGroupName(String groupName) {
    this.groupName.value = groupName;
  }

  void onCreateGroupTapped() async {
    isLoading.value = true;
    bool success =
        await heliosRepository.createGroup(Group(label: groupName.value));
    if (success) {
      Get.snackbar("Group creation", "Group created successfully");
      loadGroups();
    } else {
      Get.snackbar("Group creation", "Group not registered");
    }
    isLoading.value = false;
  }

  void onDeleteGroupTapped() async {
    isLoading.value = true;
    String groupId = groupsMap.entries
        .firstWhere(
            (element) => element.value == currentGroupLabelToDelete.value)
        .key;
    bool success = await heliosRepository.deleteGroupById(groupId);
    if (success) {
      Get.snackbar("Group removal", "Group removed successfully");
      loadGroups();
    } else {
      Get.snackbar("Group removal", "Group not removed");
    }
    isLoading.value = false;
  }

  void onDeleteGroupChanged(String groupLabel) {
    currentGroupLabelToDelete.value = groupLabel;
  }
}
