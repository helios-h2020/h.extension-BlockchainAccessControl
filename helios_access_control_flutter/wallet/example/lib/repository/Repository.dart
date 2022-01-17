import 'package:wallet/wallet.dart';
import 'package:flutter/widgets.dart';

abstract class HeliosWalletRepository {
  Future<CreateWalletResponse> createWallet({
    @required String pass,
  });

  Future<WalletCredentialsResponse> getWalletCredentials({
    @required String pass,
    @required String mnemonic,
  });
}
