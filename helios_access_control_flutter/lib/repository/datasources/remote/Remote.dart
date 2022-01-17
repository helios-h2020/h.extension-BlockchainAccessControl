import 'package:helios_access_control_ui/model/Authentication.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/model/Group.dart';
import 'package:helios_access_control_ui/model/Notifications.dart';
import 'package:helios_access_control_ui/model/Request.dart';
import 'package:helios_access_control_ui/model/Resource.dart';

abstract class HeliosRemote {
  Future<UserRegisterResponse> registerUser(UserRegisterRequest authRegisterRequest);

  Future<UserLoginResponse> login(UserLoginRequest userLoginRequest);

  Future<List<Content>> getContents();

  Future<Resource> getResource(Content content);

  Future<bool> createResource(UploadResource uploadResource);

  Future<bool> createGroup(Group group);

  Future<bool> deleteGroupById(String groupId);

  Future<List<Group>> getAllGroups();

  Future<CreateRequestResponse> createAccessRequest(Content content);

  Future<bool> grantAccessRequest(AppNotification notification);

  Future<bool> rejectAccessResponse(AppNotification notification);

  Future<List<AppNotification>> getNotifications(NotificationStatus notificationStatus);
}
