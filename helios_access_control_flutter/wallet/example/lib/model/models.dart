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

  void setCredentials(String address, String privateKey) {
    credentials = WalletCredentials(address, privateKey);
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
