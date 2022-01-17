# wallet

Flutter package to create or import wallet from Flutter.

```
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
```

```
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
``

