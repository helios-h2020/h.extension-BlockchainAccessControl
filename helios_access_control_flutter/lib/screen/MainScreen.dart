import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/viewmodel/MainViewModel.dart';

class MainScreen extends StatelessWidget {
  final _model = Get.put(MainViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _model.getCurrentTab()),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: DI.mainBottomNavBackgroundColor,
          selectedItemColor: DI.mainBottomNavSelectedColor,
          unselectedItemColor: DI.mainBottomNavUnselectedColor,
          onTap: _model.onTabTapped,
          currentIndex: _model.currentIndex.value,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/icon/ic_home.svg", color: DI.mainBottomNavUnselectedColor),
              activeIcon: SvgPicture.asset("assets/icon/ic_home.svg", color: DI.mainBottomNavSelectedColor),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/icon/ic_teams.svg", color: DI.mainBottomNavUnselectedColor),
              activeIcon: SvgPicture.asset("assets/icon/ic_teams.svg", color: DI.mainBottomNavSelectedColor),
              label: "Manage groups",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/icon/ic_notifications.svg", color: DI.mainBottomNavUnselectedColor),
              activeIcon: SvgPicture.asset("assets/icon/ic_notifications.svg", color: DI.mainBottomNavSelectedColor),
              label: "Notifications",
            ),
          ],
        ),
      ),
    );
  }
}
