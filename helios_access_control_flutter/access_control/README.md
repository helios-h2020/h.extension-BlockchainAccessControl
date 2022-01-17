# access_control

Flutter package to use the access control module from flutter

```
  Future<CreateAccessResponse> createAccessRequest({
    @required String privateKey,
    @required String uri,
  });

  Future<AcceptAccessResponse> acceptAccessRequest({
    @required String requester,
    @required String privateKey,
    @required String uri,
  });

  Future<RejectAccessResponse> rejectAccessRequest({
    @required String requester,
    @required String privateKey,
    @required String uri,
  });

  Future<CheckAccessResponse> checkAccessRequest(
      {@required String privateKey,
      @required String requester,
      @required String owner,
      @required String uri,
      @required String accessKey});

  Future<ResetAccessResponse> resetAccessRequest({
    @required String privateKey,
    @required String uri,
  });
```

abstract class SdkResponse {
  bool success;
  PlatformException platformException;

  SdkResponse({this.success, this.platformException});
}

class SetupAccessKeyResponse extends SdkResponse {}

class CreateAccessResponse extends SdkResponse {
  AccessControlError accessControlError;
}

enum AccessControlError {
  REQUEST_ALREADY_EXISTS,
  REQUEST_NOT_EXISTS,
  REQUEST_OTHER_GRANTER,
  REQUEST_ALREADY_ACCEPTED,
  REQUEST_ALREADY_REJECTED,
  REQUEST_ACCEPTED_OTHER_GRANTER,
  REQUEST_REJECTED_OTHER_GRANTER,
  ACCESS_KEY_INCORRECT_KEY,
  UNKNOWN
}

```
AccessResponse extends SdkResponse {}

class RejectAccessResponse extends SdkResponse {
  AccessControlError accessControlError;
}

class CheckAccessResponse extends SdkResponse {
  RequestStatus requestStatus;
}

class ResetAccessResponse extends SdkResponse {}

enum RequestStatus {
  PENDING,
  ACCEPTED,
  REJECTED,
  UNKNOWN
}
```



