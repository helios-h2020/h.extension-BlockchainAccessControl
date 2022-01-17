import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Authentication.dart';
import 'package:helios_access_control_ui/repository/Repository.dart';
import 'package:helios_access_control_ui/screen/MainScreen.dart';

class LoginViewModel {
  String heliosAddress = "";
  String privateKey = "";
  String username = "";
  String password = "";
  bool isLoading = false;

  final HeliosRepository heliosRepository;

  LoginViewModel(this.heliosRepository);

  Color loginButtonBackgroundColor() {
    return (userSelected())
        ? DI.enabledButtonBackgroundColor
        : DI.disabledButtonBackgroundColor;
  }

  Color loginButtonTextColor() {
    print(userSelected());
    return (userSelected())
        ? DI.enabledButtonTextColor
        : DI.disabledButtonTextColor;
  }

  void onLoginTapped() async {
    if (userSelected()) {
      isLoading = true;
      UserLoginResponse userLoginResponse = await heliosRepository.login(
        username: username,
        password: password,
      );
      if (userLoginResponse.isSuccess()) {
        Get.offAll(MainScreen());
      } else {
        Get.snackbar("User login", "Wrong credentials, try again");
      }
      isLoading = false;
    } else {
      username = "";
      password = "";
    }
  }

  void onPasswordRecoveryTapped() {}

  void onRegisterTapped() async {
    isLoading = true;
    UserRegisterResponse response = await heliosRepository.registerUser(
      username: username,
      password: password,
    );
    if (response.isSuccess()) {
      Get.snackbar("User registration", "User registered successfully");
    } else {
      Get.snackbar("User registration", "User not registered");
    }
    isLoading = false;
  }

  bool userSelected() {
    return username != "" && password != "";
  }

  void setUsername(String value) {
    username = value;
  }

  void setPassword(String value) {
    password = value;
  }
}
