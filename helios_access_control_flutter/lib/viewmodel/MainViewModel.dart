import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/screen/HomeScreen.dart';
import 'package:helios_access_control_ui/screen/ManageGroupsScreen.dart';
import 'package:helios_access_control_ui/screen/NotificationsScreen.dart';

class MainViewModel extends GetxController{
  var currentIndex = 0.obs;
  final List<Widget> _children = [
    HomeScreen(),
    ManageGroupsScreen(),
    NotificationsScreen(),
  ];

  Widget getCurrentTab() {
    return _children[currentIndex.value];
  }

  void onTabTapped(int index) {
    this.currentIndex.value = index;
  }

}