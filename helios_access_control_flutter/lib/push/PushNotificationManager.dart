//Original code: https://medium.com/@SebastianEngel/easy-push-notifications-with-flutter-and-firebase-cloud-messaging-d96084f5954f

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/utils/DialogUtils.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotificationsManager {
  final FirebaseMessaging _firebaseMessaging;

  PushNotificationsManager(this._firebaseMessaging);

  bool _initialized = false;

  Future init(BuildContext buildContext) async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestPermission();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        var title = message.notification?.title ?? "";
        var body = message.notification?.body ?? "";
        _showPushNotificationDialog(title: title, body: body);
      });

      _initialized = true;

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        //This callback is executed only is app is in background
        var title = message.notification?.title ?? "";
        var body = message.notification?.body ?? "";
        _showPushNotificationDialog(title: title, body: body);
      });

      RemoteMessage message =
          await FirebaseMessaging.instance.getInitialMessage();
      if (message != null){
        //This is executed only if app is not alive
        //Before navigate to desired screen, navigate to home screen.
        //In this way, when we press 'back' we come back to home screen
        var title = message.notification?.title ?? "";
        var body = message.notification?.body ?? "";
        _showPushNotificationDialog(title: title, body: body);
      }
    }
    return true;
  }

  void _showPushNotificationDialog({String title, String body}) {
    showOverlay(
      (context, progress) {
        return Container(
          color: Color.lerp(Colors.transparent, Colors.black54, progress),
          child: TopSlideNotification(
            builder: (context) => DialogUtils.buildCustomContentConfirmDialog(
                title: title,
                content: Text(
                  body,
                  style: TextStyle(color: DI.textColorGrey, fontSize: 17),
                ),
                cancelText: null,
                confirmText: "OK",
                onCancelPressed: () =>
                    OverlaySupportEntry.of(context)?.dismiss(),
                onConfirmPressed: () {
                  OverlaySupportEntry.of(context)?.dismiss();
                }),
            progress: progress,
          ),
        );
      },
      duration: Duration.zero,
    );
  }

  Future<String> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }
}
