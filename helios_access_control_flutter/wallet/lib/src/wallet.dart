import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'types/types.dart';

class Wallet {
  static const MethodChannel _channel = const MethodChannel('wallet');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<CreateWalletResponse> createWallet({
    @required String pass,
  }) async {
    try {
      final wallet = await _channel.invokeMethod('createWallet', {
        "pass": pass,
      });
      return CreateWalletResponse(
        mnemonic: wallet["mnemonic"],
      )..success = true;
    } on PlatformException catch (e) {
      print('PlatformException in createWallet: ${e.message}');
      return CreateWalletResponse()
        ..success = false
        ..platformException = e;
    }
  }

  Future<WalletCredentialsResponse> getWalletCredentials(
      {@required String pass, @required String mnemonic}) async {
    try {
      final addressResponse =
          await _channel.invokeMethod('getWalletCredentials', {
        "pass": pass,
        "mnemonic": mnemonic,
      });
      return WalletCredentialsResponse(
        address: addressResponse["address"],
        privateKey: addressResponse["privateKey"],
      )..success = true;
    } on PlatformException catch (e) {
      print('PlatformException in createAddress: ${e.message}');
      return WalletCredentialsResponse()
        ..success = false
        ..platformException = e;
    }
  }
}
