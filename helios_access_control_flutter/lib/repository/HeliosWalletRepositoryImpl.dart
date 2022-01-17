import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/model/wallet/Wallet.dart';
import 'package:wallet/wallet.dart';

import 'Repository.dart';
import 'datasources/preferences/Settings.dart';

class HeliosWalletRepositoryImpl extends HeliosWalletRepository {
  final Wallet wallet;
  final Settings settings;

  HeliosWalletRepositoryImpl(this.wallet, this.settings);

  @override
  Future<CreateWalletResponse> createWallet({
    @required String pass,
  }) {
    return wallet.createWallet(pass: pass);
  }

  @override
  Future<WalletCredentialsResponse> getWalletCredentials({
    @required String pass,
    @required String mnemonic,
  }) {
    return wallet.getWalletCredentials(pass: pass, mnemonic: mnemonic);
  }

  @override
  Future<void> saveWalletCredentials({WalletModel walletModel}) {
    settings.setPublicAddress(walletModel.credentials.address);
    settings.setPrivateKey(walletModel.credentials.privateKey);
    return Future.value();
  }

  @override
  Future<bool> isWalletCreated() {
    return Future.value(false);
  }
}
