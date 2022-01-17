import 'package:flutter/services.dart';

abstract class SdkResponse {
  bool success;
  PlatformException platformException;

  SdkResponse({this.success, this.platformException});
}

class CreateWalletResponse extends SdkResponse {
  String mnemonic;

  CreateWalletResponse({this.mnemonic});
}

class WalletCredentialsResponse extends SdkResponse {
  String address;
  String privateKey;

  WalletCredentialsResponse({this.address, this.privateKey});
}