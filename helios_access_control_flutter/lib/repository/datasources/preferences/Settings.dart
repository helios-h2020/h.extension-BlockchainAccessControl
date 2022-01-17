abstract class Settings {
  bool hasUserName();
  Future<void> setUserName(String username);
  String getUserName();

  bool hasUserId();
  Future<void> setUserId(String userId);
  String getUserId();

  bool hasPassword();
  Future<void> setPassword(String password);
  String getPassword();

  bool hasUserToken();
  Future<void> setUserToken(String userToken);
  String getUserToken();
  Future<void> clearUserToken();

  Future<void>  setPublicAddress(String publicAddress);
  String getPublicAddress();

  Future<void>  setPrivateKey(String privateKey);
  String getPrivateKey();

}