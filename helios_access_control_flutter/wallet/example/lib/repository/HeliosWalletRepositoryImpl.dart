import 'package:wallet/wallet.dart';
import 'package:flutter/widgets.dart';

import 'Repository.dart';

class HeliosWalletRepositoryImpl extends HeliosWalletRepository {
  final Wallet wallet;

  HeliosWalletRepositoryImpl(this.wallet);

  @override
  Future<CreateWalletResponse> createWallet({
    @required String pass,
  }) {
    return wallet.createWallet(pass: pass);
  }

  @override
  Future<WalletCredentialsResponse> getWalletCredentials({
    @required String pass,
    @required mnemonic,
  }) {
    return wallet.getWalletCredentials(pass: pass, mnemonic: mnemonic);
  }
}
