import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/screen/LoginScreen.dart';
import 'package:helios_access_control_ui/screen/wallet/WalletFlowScreen.dart';

class SplashViewModel extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _goToHomeDelayed(3);
  }

  void _goToHomeDelayed(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
    Get.offAll(WalletFlowScreen());
  }
}