import 'package:wallet/wallet.dart';

class WalletModel {
  final String passphrase;
  final String mnemonic;
  WalletCredentials credentials;

  WalletModel({
    this.passphrase,
    this.mnemonic,
    this.credentials,
  }) {
    this.credentials = WalletCredentials("", "");
  }

  void setCredentials(WalletCredentialsResponse credentialsResponse) {
    credentials = WalletCredentials(
      credentialsResponse.address,
      credentialsResponse.privateKey,
    );
  }

  bool isValid() {
    return credentials.isValid();
  }
}

class WalletCredentials {
  final String address;
  final String privateKey;

  WalletCredentials(
    this.address,
    this.privateKey,
  );

  bool isValid() {
    return address != null &&
        address.isNotEmpty &&
        privateKey != null &&
        privateKey.isNotEmpty;
  }
}
