import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/viewmodel/SplashViewModel.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashViewModel _model = Get.put(SplashViewModel());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await DI.pushManager.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 44),
          Image.asset(
            "assets/img/img_helios_logo.png",
            width: 200,
            height: 106,
          ),
          Image.asset(
            "assets/img/img_splash.png",
            width: 423,
            height: 317,
          ),
          Image.asset(
            "assets/img/img_splash_title_bottom.png",
          ),
        ],
      ),
    );
  }
}
