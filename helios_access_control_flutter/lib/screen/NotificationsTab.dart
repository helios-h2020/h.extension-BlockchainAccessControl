import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/Notifications.dart';
import 'package:helios_access_control_ui/viewmodel/NotificationsViewModel.dart';
import 'package:helios_access_control_ui/widgets/forms/AppButton.dart';
import 'package:helios_access_control_ui/widgets/forms/OutlineAppButton.dart';
import 'package:intl/intl.dart';

const _approvedColor = Color(0xFFEC7211);
const _styleApproved = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: _approvedColor,
);

class NotificationsTab extends StatefulWidget {
  final NotificationStatus notificationStatus;

  NotificationsTab(this.notificationStatus);

  @override
  _NotificationsTabState createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  NotificationsViewModel _model;

  @override
  void initState() {
    super.initState();
    _model = Get.put(
      NotificationsViewModel(widget.notificationStatus),
      tag: widget.notificationStatus.asString,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _model.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _getNotifications,
              child: ListView.separated(
                itemCount: _model.appNotifications.length,
                itemBuilder: (context, index) {
                  final currentItem = _model.appNotifications[index];
                  return Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 19),
                    child: NotificationItem(
                        item: currentItem,
                        status: widget.notificationStatus,
                        onTapApprove: () async {
                          await _model.approveAccessRequest(currentItem);
                        },
                        onTapReject: () async {
                          await _model.rejectAccessRequest(currentItem);
                        }),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 1,
                    color: DI.notificationDividerColor,
                  );
                },
              ),
            );
    });
  }

  Future<void> _getNotifications() async {
    _model.getNotifications(widget.notificationStatus);
  }
}

class NotificationItem extends StatelessWidget {
  final _dateFormat = DateFormat("dd/MM/yyyy");

  NotificationItem(
      {Key key, this.item, this.status, this.onTapApprove, this.onTapReject})
      : super(key: key);

  final AppNotification item;
  final NotificationStatus status;
  final Function onTapApprove;
  final Function onTapReject;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.type.asString, style: DI.notificationCardHeaderStyle),
            Text(_dateFormat.format(item.creationTime),
                style: DI.notificationCardHeaderStyle)
          ],
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: DI.notificationCardTitle),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(item.resourceId, style: DI.notificationCardSubtitle),
          ],
        ),
        SizedBox(height: 16),
        if (status == NotificationStatus.PENDING)
          Visibility(
            visible: item.actionsEnabled,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlineAppButton(
                  label: "REJECT",
                  onTap: onTapReject,
                ),
                SizedBox(width: 16),
                AppButton(
                  label: "APPROVE",
                  onTap: onTapApprove,
                ),
              ],
            ),
          ),
        if (status == NotificationStatus.APPROVED)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: item.actionsEnabled,
                child: Row(
                  children: [
                    OutlineAppButton(
                      label: "REJECT",
                      onTap: onTapReject,
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
              Text("Approved".toUpperCase(), style: _styleApproved),
              SizedBox(width: 8),
              Icon(Icons.check, color: _approvedColor)
            ],
          ),
      ],
    );
  }
}
