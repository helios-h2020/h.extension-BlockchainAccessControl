import 'package:helios_access_control_ui/repository/datasources/preferences/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeliosSettings extends Settings {
  static const String _USER_NAME = "USER_NAME";
  static const String _USER_ID = "USER_ID";
  static const String _PASSWORD = "PASSWORD";
  static const String _USER_TOKEN = "USER_TOKEN";
  static const String _PRIVATE_KEY = "PRIVATE_KEY";
  static const String _PUBLIC_ADDRESS = "PUBLIC_ADDRESS";

  final SharedPreferences _prefs;

  HeliosSettings(this._prefs);

  @override
  String getPassword() {
    return _prefs.getString(_PASSWORD);
  }

  @override
  String getUserName() {
    return _prefs.getString(_USER_NAME);
  }

  @override
  String getUserId() {
    return _prefs.getString(_USER_ID);
  }

  @override
  String getUserToken() {
    return _prefs.getString(_USER_TOKEN);
  }

  @override
  bool hasPassword() {
    return _prefs.containsKey(_PASSWORD);
  }

  @override
  bool hasUserName() {
    return _prefs.containsKey(_USER_NAME);
  }

  @override
  bool hasUserId() {
    return _prefs.containsKey(_USER_ID);
  }

  @override
  bool hasUserToken() {
    return _prefs.containsKey(_USER_TOKEN);
  }

  @override
  Future<void> setPassword(String password) async {
    await _prefs.setString(_PASSWORD, password);
  }

  @override
  Future<void> setUserName(String username) async {
    await _prefs.setString(_USER_NAME, username);
  }

  @override
  Future<void> setUserId(String userId) async {
    await _prefs.setString(_USER_ID, userId);
  }

  @override
  Future<void> setUserToken(String userToken) async {
    await _prefs.setString(_USER_TOKEN, userToken);
  }

  @override
  Future<void> clearUserToken() async {
    if (hasUserToken()) {
      await _prefs.remove(_USER_TOKEN);
    }
  }

  @override
  String getPublicAddress() {
    return _prefs.getString(_PUBLIC_ADDRESS);
  }

  @override
  Future<void> setPublicAddress(String publicAddress) {
    return _prefs.setString(_PUBLIC_ADDRESS, publicAddress);
  }

  @override
  String getPrivateKey() {
    return _prefs.getString(_PRIVATE_KEY);
  }

  @override
  Future<void> setPrivateKey(String privateKey) {
    return _prefs.setString(_PRIVATE_KEY, privateKey);
  }
}
