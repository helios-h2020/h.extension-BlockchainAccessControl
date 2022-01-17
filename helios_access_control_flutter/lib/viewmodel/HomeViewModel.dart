import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/navigation/AppNavigator.dart';
import 'package:helios_access_control_ui/screen/DetailContentScreen.dart';

class HomeViewModel extends GetxController {
  var contents = <Content>[].obs;
  var isLoading = false.obs;

  final AppNavigator appNavigator;

  HomeViewModel(this.appNavigator);

  @override
  void onReady() {
    super.onReady();
    getContents();
  }

  void getContents() async {
    isLoading.value = true;
    await DI.heliosRepository.cleanResourceFiles();
    List<Content> newContents = await DI.heliosRepository.getContents();
    contents.assignAll(newContents);
    isLoading.value = false;
  }

  void _goToDetail(Content content) {
    Get.to(DetailContentScreen(), arguments: content);
  }

  Future<void> onSeeContentTapped(Content content) async {
    _goToDetail(content);
  }

  void onInfoTapped(Content content) {
    _goToDetail(content);
  }

  Future<void> onAddContentTapped() async {
    bool reload = await appNavigator.goToCreateResourceScreen();
    if (reload) {
      getContents();
    }
  }
}
