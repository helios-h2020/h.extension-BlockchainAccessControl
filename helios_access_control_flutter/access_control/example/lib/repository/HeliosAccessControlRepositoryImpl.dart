import 'package:access_control/access_control.dart';
import 'package:flutter/widgets.dart';

import 'Repository.dart';

class HeliosAccessControlRepositoryImpl extends HeliosAccessControlRepository {
  final AccessControl accessControl;

  HeliosAccessControlRepositoryImpl(this.accessControl);

  @override
  Future<SetupAccessKeyResponse> setupAccessKey({
    @required String accessKey,
    @required String privateKey,
  }) {
    return accessControl.setupAccessKey(
      accessKey: accessKey,
      privateKey: privateKey,
    );
  }

  @override
  Future<CreateAccessResponse> createAccessRequest({
    @required String uri,
    @required String privateKey,
  }) {
    return accessControl.createAccessRequest(uri: uri, privateKey: privateKey);
  }

  @override
  Future<AcceptAccessResponse> acceptAccessRequest({
    @required String uri,
    @required String requester,
    @required String privateKey,
  }) {
    return accessControl.acceptAccessRequest(
      uri: uri,
      requester: requester,
      privateKey: privateKey,
    );
  }

  @override
  Future<RejectAccessResponse> rejectAccessRequest({
    @required String uri,
    @required String requester,
    @required String privateKey,
  }) {
    return accessControl.rejectAccessRequest(
      uri: uri,
      requester: requester,
      privateKey: privateKey,
    );
  }

  @override
  Future<CheckAccessResponse> checkAccessRequest({
    @required String owner,
    @required String uri,
    @required String accessKey,
    @required String privateKey,
    @required String requester,
  }) {
    return accessControl.checkAccessRequest(
      owner: owner,
      uri: uri,
      accessKey: accessKey,
      privateKey: privateKey,
      requester: requester,
    );
  }

  @override
  Future<ResetAccessResponse> resetAccessRequest({
    @required String uri,
    @required String privateKey,
  }) {
    return accessControl.resetAccessRequest(uri: uri, privateKey: privateKey);
  }
}
