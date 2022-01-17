import 'package:flutter/cupertino.dart';
import 'package:helios_access_control_ui/model/Authentication.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:helios_access_control_ui/model/Group.dart';
import 'package:helios_access_control_ui/model/Notifications.dart';
import 'package:helios_access_control_ui/model/Resource.dart';
import 'package:helios_access_control_ui/model/wallet/Wallet.dart';
import 'package:wallet/wallet.dart';

abstract class HeliosRepository {
  Future<UserRegisterResponse> registerUser({
    @required String username,
    @required String password,
  });

  Future<UserLoginResponse> login({
    @required String username,
    @required String password,
  });

  Future<List<Content>> getContents();

  Future<bool> cleanResourceFiles();

  Future<Resource> getResource(Content content);

  Future<bool> createResource(UploadResource uploadResource);

  Future<bool> requestAccess(Content content);

  Future<bool> createGroup(Group group);

  Future<bool> deleteGroupById(String groupId);

  Future<List<Group>> getAllGroups();

  Future<bool> grantAccessRequest(AppNotification notification);

  Future<bool> rejectAccessRequest(AppNotification notification);

  Future<List<AppNotification>> getNotifications(
      NotificationStatus notificationStatus);

  Future<bool> checkAccessRequest(Content content);
}

abstract class HeliosWalletRepository {
  Future<CreateWalletResponse> createWallet({
    @required String pass,
  });

  Future<WalletCredentialsResponse> getWalletCredentials({
    @required String pass,
    @required String mnemonic,
  });

  Future<void> saveWalletCredentials({@required WalletModel walletModel});

  Future<bool> isWalletCreated();
}
