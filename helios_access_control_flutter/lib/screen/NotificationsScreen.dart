import 'package:flutter/material.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Notifications.dart';

import 'NotificationsTab.dart';

const _styleTabTitle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
);
final Color _tabBarContainerColor = DI.primaryColor;
const Color _selectedTabColor = Colors.white;
const Color _unselectedLabelColor = Color(0xFF7BBBDC);
const Color _tabIndicatorColor = Color(0xFFF79F25);

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: DI.topBarBackgroundColor,
          title: Text(
            "Notifications",
            style: TextStyle(
              color: DI.topBarItemsColor,
              fontSize: 20,
              fontWeight: DI.robotoMedium,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: _tabBarContainerColor,
              child: TabBar(
                tabs: [
                  headerTab("Pending", Icons.access_time),
                  headerTab("Approved", Icons.check),
                ],
                indicatorWeight: 4.0,
                labelColor: _selectedTabColor,
                unselectedLabelColor: _unselectedLabelColor,
                indicatorColor: _tabIndicatorColor,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  NotificationsTab(NotificationStatus.PENDING),
                  NotificationsTab(NotificationStatus.APPROVED),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerTab(String label, IconData iconData) {
    return SizedBox(
      height: 72,
      child: Tab(
          icon: Icon(iconData, size: 24),
          child: Text(
            label.toUpperCase(),
            style: _styleTabTitle,
          )),
    );
  }
}
