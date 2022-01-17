import 'package:access_control/access_control.dart';
import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/model/Authentication.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/model/Group.dart';
import 'package:helios_access_control_ui/model/Notifications.dart';
import 'package:helios_access_control_ui/model/Request.dart';
import 'package:helios_access_control_ui/model/Resource.dart';
import 'package:helios_access_control_ui/push/PushNotificationManager.dart';
import 'package:helios_access_control_ui/repository/Repository.dart';
import 'package:helios_access_control_ui/repository/datasources/file/ResourceFileInteractor.dart';
import 'package:helios_access_control_ui/repository/datasources/preferences/Settings.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/Remote.dart';

class HeliosRepositoryImpl implements HeliosRepository {
  final HeliosRemote heliosRemote;
  final ResourceFilesInteractor resourceFilesInteractor;
  final Settings settings;
  final AccessControl accessControl;
  final PushNotificationsManager pushNotificationsManager;

  HeliosRepositoryImpl(
    this.heliosRemote,
    this.resourceFilesInteractor,
    this.settings,
    this.pushNotificationsManager,
    this.accessControl,
  );

  @override
  Future<UserRegisterResponse> registerUser({
    @required String username,
    @required String password,
  }) async {
    String publicAddress = await settings.getPublicAddress();
    String fcmToken = await pushNotificationsManager.getFcmToken();
    return heliosRemote.registerUser(UserRegisterRequest(
      id: publicAddress,
      name: username,
      pass: password,
      fcmToken: fcmToken,
    ));
  }

  @override
  Future<UserLoginResponse> login({
    @required String username,
    @required String password,
  }) async {
    try {
      await accessControl.checkAccessRequest(
        privateKey: settings.getPrivateKey(),
        requester: settings.getPublicAddress(),
        owner: "owner",
        uri: "",
        accessKey: password,
      );
    } catch (e) {
      print("ERROR LOGIN");
    }
    await settings.clearUserToken();
    String fcmToken = await pushNotificationsManager.getFcmToken();
    String publicAddress = await settings.getPublicAddress();
    UserLoginResponse userLoginResponse =
        await heliosRemote.login(UserLoginRequest(
      id: publicAddress,
      pass: password,
      fcmToken: fcmToken,
    ));
    if (userLoginResponse.isSuccess()) {
      /*await accessControl.setupAccessKey(
          privateKey: settings.getPrivateKey(), accessKey: "123456");*/
      settings.setUserName(username);
      settings.setPassword(password);
      settings.setUserToken(userLoginResponse.userToken);
    }
    return userLoginResponse;
  }

  @override
  Future<List<Content>> getContents() {
    return heliosRemote.getContents();
  }

  @override
  Future<Resource> getResource(Content content) async {
    return heliosRemote.getResource(content);
  }

  @override
  Future<bool> createResource(UploadResource uploadResource) {
    return heliosRemote.createResource(uploadResource);
  }

  @override
  Future<bool> createGroup(Group group) {
    return heliosRemote.createGroup(group);
  }

  @override
  Future<bool> deleteGroupById(String groupId) {
    return heliosRemote.deleteGroupById(groupId);
  }

  @override
  Future<List<Group>> getAllGroups() {
    return heliosRemote.getAllGroups();
  }

  @override
  Future<bool> requestAccess(Content content) async {
    bool success = false;
    CreateAccessResponse createAccessResponse =
        await accessControl.createAccessRequest(
      privateKey: settings.getPrivateKey(),
      uri: content.requestAccessId,
    );
    if (createAccessResponse.success ||
        (createAccessResponse.accessControlError ==
            AccessControlError.REQUEST_ALREADY_EXISTS)) {
      CreateRequestResponse createRequestResponse =
          await heliosRemote.createAccessRequest(content);
      return createRequestResponse.isSuccess();
    } else {
      success = false;
    }
    return success;
  }

  @override
  Future<bool> grantAccessRequest(AppNotification notification) async {
    bool granted;
    AcceptAccessResponse acceptAccessResponse =
        await accessControl.acceptAccessRequest(
      requester: notification.requesterId,
      privateKey: settings.getPrivateKey(),
      uri: notification.resourceId,
    );
    if (acceptAccessResponse.success) {
      return heliosRemote.grantAccessRequest(notification);
    } else {
      granted = false;
    }
    return granted;
  }

  @override
  Future<bool> rejectAccessRequest(AppNotification notification) async {
    bool rejected;
    RejectAccessResponse rejectAccessResponse =
        await accessControl.rejectAccessRequest(
      requester: notification.requesterId,
      privateKey: settings.getPrivateKey(),
      uri: notification.resourceId,
    );
    if (rejectAccessResponse.success ||
        (rejectAccessResponse.accessControlError ==
            AccessControlError.REQUEST_ALREADY_REJECTED)) {
      return heliosRemote.rejectAccessResponse(notification);
    } else {
      rejected = false;
    }
    return rejected;
  }

  @override
  Future<List<AppNotification>> getNotifications(
      NotificationStatus notificationStatus) async {
    List<AppNotification> notifications =
        await heliosRemote.getNotifications(notificationStatus);
    for (var notification in notifications) {
      notification.actionsEnabled = notification.actionsEnabled;
    }
    return notifications;
  }

  @override
  Future<bool> checkAccessRequest(Content content) async {
    CheckAccessResponse response = await accessControl.checkAccessRequest(
      privateKey: settings.getPrivateKey(),
      requester: settings.getUserId(),
      owner: "owner",
      uri: content.id,
      accessKey: "accessKey",
    );

    return response.success;
  }

  @override
  Future<bool> cleanResourceFiles() async {
    await resourceFilesInteractor.deleteResourcesPathIfExists();
    return true;
  }
}
