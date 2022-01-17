import 'package:flutter/material.dart';
import 'package:wallet/wallet.dart';
import 'package:wallet_example/repository/HeliosWalletRepositoryImpl.dart';
import 'package:wallet_example/repository/Repository.dart';

class DI {

  static final Color primaryColor = Color(0xFF007DBC);
  static final Color inputDecorationColor = primaryColor;
  static final Color emptyValueColor = Color(0xFF666666);
  static final Color inputTextColor = Colors.black;
  static final Color errorTextColor = Colors.red;
  static final Color underlineColor = Color(0xFF808080);
  static final Color underlineFocusedColor = primaryColor;

  static final HeliosWalletRepository heliosWalletRepository =
      HeliosWalletRepositoryImpl(Wallet());
}
