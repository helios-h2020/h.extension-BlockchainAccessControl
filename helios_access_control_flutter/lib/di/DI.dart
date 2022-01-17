import 'package:access_control/access_control.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helios_access_control_ui/navigation/AppNavigator.dart';
import 'package:helios_access_control_ui/push/PushNotificationManager.dart';
import 'package:helios_access_control_ui/repository/HeliosRepositoryImpl.dart';
import 'package:helios_access_control_ui/repository/HeliosWalletRepositoryImpl.dart';
import 'package:helios_access_control_ui/repository/Repository.dart';
import 'package:helios_access_control_ui/repository/datasources/file/ResourceFileInteractor.dart';
import 'package:helios_access_control_ui/repository/datasources/preferences/HeliosSettings.dart';
import 'package:helios_access_control_ui/repository/datasources/preferences/Settings.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/DioClient.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/HeliosRemote.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/wallet.dart';

class DI {
  static SharedPreferences _prefs;

  //Styles that at some point could be moved to AppTheme
  static final Color primaryColor = Color(0xFF007DBC);
  static final Color inputDecorationColor = primaryColor;
  static final Color emptyValueColor = Color(0xFF666666);
  static final Color inputTextColor = Colors.black;
  static final Color errorTextColor = Colors.red;
  static final Color underlineColor = Color(0xFF808080);
  static final Color underlineFocusedColor = primaryColor;
  static final Color buttonBgColor = primaryColor;
  static final Color buttonDisabledBgColor = Color(0xFFD5DBDB);
  static final Color dividerBgColor = Color(0xFFD5DBDB);
  static final Color buttonTextColor = Colors.white;
  static final Color buttonDisabledTextColor = Color(0xFFAAB7B8);
  static final Color textColorGrey = Color(0xFF696973);

  //Notifications
  static final TextStyle notificationCardHeaderStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Color(0xFF879196),
  );

  static final TextStyle notificationCardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static final TextStyle notificationCardSubtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF666666),
  );
  static final Color notificationDividerColor = Color(0xFFCCCCCC);

  //fonts
  static final FontWeight robotoRegular = FontWeight.w400;
  static final FontWeight robotoMedium = FontWeight.w500;
  static final FontWeight robotoBold = FontWeight.bold;

  //Colors
  static final Color topBarBackgroundColor = Color(0xFFEAEDED);
  static final Color topBarItemsColor = Color(0xFF007DBC);

  static final Color homeDocumentColor = Color(0xFFF79F25);
  static final Color homeVideoColor = Color(0xFFEB5F07);
  static final Color homeImageColor = Color(0xFF00A1C9);
  static final Color homeDividerColor = Color(0xFFEAEDED);
  static final Color homeContentTitleColor = Color(0xFF16191F);
  static final Color homeContentIdColor = Color(0xFF879196);
  static final Color homeContentInfoButtonColor = Color(0xFF16191F);
  static final Color homeContentSeeContentButtonColor = Color(0xFF16191F);

  static final Color mainBottomNavSelectedColor = Color(0xFF007DBC);
  static final Color mainBottomNavUnselectedColor = Color(0xFF545B64);
  static final Color mainBottomNavBackgroundColor = Color(0xFFEAEDED);

  static final Color detailContentTitleColor = Color(0xFF16191F);
  static final Color detailContentIdColor = Color(0xFF879196);
  static final Color detailLockIconColor = Color(0xFFEB5F07);
  static final Color detailCircleColor = Color(0xFFEAEDED);
  static final Color detailPrivateColor = Color(0xFF879196);
  static final Color detailPendingApprovalColor = Color(0xFFEB5F07);
  static final Color detailAccessButton = Color(0xFF007DBC);

  static final Color dialogTitleColor = Color(0xFF000000);
  static final Color dialogMiddleTextColor = Color(0xFF666666);
  static final Color dialogConfirmColor = Color(0xFF007DBC);

  static final Color enabledButtonBackgroundColor = Color(0xFF007DBC);
  static final Color disabledButtonBackgroundColor = Color(0xFFD5DBDB);
  static final Color enabledButtonTextColor = Color(0xFFFFFFFF);
  static final Color disabledButtonTextColor = Color(0xFFAAB7B8);

  static final Color loginButtonsColor = Color(0xFF007DBC);
  static final Color createResourceButtonColor = Color(0xFF007DBC);

  static final Settings settings = HeliosSettings(_prefs);

  static final PushNotificationsManager pushManager =
      PushNotificationsManager(FirebaseMessaging.instance);

  static final ResourceFilesInteractor resourcesFileInteractor =
      ResourceFilesInteractorImpl();

  static final HeliosRepository heliosRepository = HeliosRepositoryImpl(
      HeliosRemoteImpl(DioClient(settings), resourcesFileInteractor),
      resourcesFileInteractor,
      settings,
      pushManager,
      AccessControl());

  static final HeliosWalletRepository heliosWalletRepository =
      HeliosWalletRepositoryImpl(Wallet(), settings);

  static final AppNavigator navigator = AppNavigator();

  void initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
