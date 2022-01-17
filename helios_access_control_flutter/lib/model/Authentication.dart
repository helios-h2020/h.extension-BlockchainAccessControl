class UserRegisterRequest {
  final String id;
  final String pass;
  final String fcmToken;
  final String name;

  UserRegisterRequest({
    this.id,
    this.pass,
    this.fcmToken,
    this.name,
  });
}

class UserRegisterResponse {
  final String content;

  UserRegisterResponse({this.content});

  static UserRegisterResponse registerFailedResponse() {
    return UserRegisterResponse(content: "");
  }

  bool isSuccess() {
    return content != null && content.isNotEmpty;
  }
}

class UserLoginRequest {
  final String id;
  final String pass;
  final String fcmToken;

  UserLoginRequest({
    this.id,
    this.pass,
    this.fcmToken,
  });
}

class UserLoginResponse {
  final String userToken;

  UserLoginResponse({this.userToken});

  static UserLoginResponse loginFailedResponse() {
    return UserLoginResponse(userToken: "");
  }

  bool isSuccess() {
    return userToken != null && userToken.isNotEmpty;
  }
}
