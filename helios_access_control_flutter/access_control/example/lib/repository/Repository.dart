import 'package:access_control/access_control.dart';
import 'package:flutter/widgets.dart';

abstract class HeliosAccessControlRepository {
  Future<SetupAccessKeyResponse> setupAccessKey({@required String accessKey});

  Future<CreateAccessResponse> createAccessRequest({
    @required String uri,
    @required String privateKey,
  });

  Future<AcceptAccessResponse> acceptAccessRequest({
    @required String uri,
    @required String requester,
    @required String privateKey,
  });

  Future<RejectAccessResponse> rejectAccessRequest({
    @required String uri,
    @required String requester,
    @required String privateKey,
  });

  Future<CheckAccessResponse> checkAccessRequest({
    @required String owner,
    @required String uri,
    @required String accessKey,
    @required String privateKey,
    @required String requester,
  });

  Future<ResetAccessResponse> resetAccessRequest({
    @required String uri,
    @required String privateKey,
  });
}
