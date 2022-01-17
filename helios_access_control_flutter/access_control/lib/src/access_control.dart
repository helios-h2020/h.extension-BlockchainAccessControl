import 'dart:async';

import 'package:access_control/access_control.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AccessControl {
  static const MethodChannel _channel = const MethodChannel('access_control');

  AccessControl();

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<SetupAccessKeyResponse> setupAccessKey({
    @required String privateKey,
    @required String accessKey,
  }) async {
    try {
      await _channel.invokeMethod('setupAccessKey', {
        "privateKey": privateKey,
        "accessKey": accessKey,
      });
      return SetupAccessKeyResponse()..success = true;
    } on PlatformException catch (e) {
      print('PlatformException in setupAccessKey: ${e.code}');
      return SetupAccessKeyResponse()
        ..success = false
        ..platformException = e;
    }
  }

  Future<CreateAccessResponse> createAccessRequest({
    @required String privateKey,
    @required String uri,
  }) async {
    try {
      await _channel.invokeMethod('createAccessRequest', {
        "privateKey": privateKey,
        "uri": uri,
      });
      return CreateAccessResponse()..success = true;
    } on PlatformException catch (e) {
      print('PlatformException in createAccessRequest: ${e.code}');
      AccessControlError accessControlError = getAccessControlError(e.code);
      return CreateAccessResponse()
        ..success = false
        ..accessControlError = accessControlError
        ..platformException = e;
    }
  }

  AccessControlError getAccessControlError(String errorCode) {
    AccessControlError createAccessError;
    switch (int.parse(errorCode)) {
      case 0:
        createAccessError = AccessControlError.REQUEST_ALREADY_EXISTS;
        break;
      case 1:
        createAccessError = AccessControlError.REQUEST_NOT_EXISTS;
        break;
      case 2:
        createAccessError = AccessControlError.REQUEST_OTHER_GRANTER;
        break;
      case 3:
        createAccessError = AccessControlError.REQUEST_ALREADY_ACCEPTED;
        break;
      case 4:
        createAccessError = AccessControlError.REQUEST_ALREADY_REJECTED;
        break;
      case 5:
        createAccessError = AccessControlError.REQUEST_ACCEPTED_OTHER_GRANTER;
        break;
      case 6:
        createAccessError = AccessControlError.REQUEST_REJECTED_OTHER_GRANTER;
        break;
      case 7:
        createAccessError = AccessControlError.ACCESS_KEY_INCORRECT_KEY;
        break;
      default:
        createAccessError = AccessControlError.UNKNOWN;
    }
    return createAccessError;
  }

  Future<AcceptAccessResponse> acceptAccessRequest({
    @required String requester,
    @required String privateKey,
    @required String uri,
  }) async {
    try {
      await _channel.invokeMethod('acceptAccessRequest', {
        "requester": requester,
        "privateKey": privateKey,
        "uri": uri,
      });
      return AcceptAccessResponse()..success = true;
    } on PlatformException catch (e) {
      print('PlatformException in acceptAccessRequest: ${e.code}');
      return AcceptAccessResponse()
        ..success = false
        ..platformException = e;
    }
  }

  Future<RejectAccessResponse> rejectAccessRequest({
    @required String requester,
    @required String privateKey,
    @required String uri,
  }) async {
    try {
      await _channel.invokeMethod('rejectAccessRequest', {
        "requester": requester,
        "privateKey": privateKey,
        "uri": uri,
      });
      return RejectAccessResponse()..success = true;
    } on PlatformException catch (e) {
      print('PlatformException in rejectAccessRequest: ${e.code}');
      AccessControlError accessControlError = getAccessControlError(e.code);
      return RejectAccessResponse()
        ..success = false
        ..accessControlError = accessControlError
        ..platformException = e;
    }
  }

  Future<CheckAccessResponse> checkAccessRequest(
      {@required String privateKey,
      @required String requester,
      @required String owner,
      @required String uri,
      @required String accessKey}) async {
    try {
      int status = await _channel.invokeMethod('checkAccessRequest', {
        "privateKey": privateKey,
        "requester": requester,
        "owner": owner,
        "uri": uri,
        "accessKey": accessKey,
      });
      RequestStatus requestStatus;
      switch (status) {
        case 0:
          requestStatus = RequestStatus.PENDING;
          break;
        case 1:
          requestStatus = RequestStatus.ACCEPTED;
          break;
        case 2:
          requestStatus = RequestStatus.REJECTED;
          break;
        default:
          requestStatus = RequestStatus.UNKNOWN;
      }
      return CheckAccessResponse()
        ..success = true
        ..requestStatus = requestStatus;
    } on PlatformException catch (e) {
      print('PlatformException in checkAccessRequest: ${e.code}');
      return CheckAccessResponse()
        ..success = false
        ..platformException = e;
    }
  }

  Future<ResetAccessResponse> resetAccessRequest({
    @required String privateKey,
    @required String uri,
  }) async {
    try {
      await _channel.invokeMethod('resetAccessRequest', {
        "privateKey": privateKey,
        "uri": uri,
      });
      return ResetAccessResponse()..success = true;
    } on PlatformException catch (e) {
      print('PlatformException in resetAccessRequest: ${e.code}');
      return ResetAccessResponse()
        ..success = false
        ..platformException = e;
    }
  }
}
