import 'package:helios_access_control_ui/model/wallet/Wallet.dart';

enum WalletFlowStep {
  SHOW_WELCOME,
  CREATE_WALLET,
  COPY_RECOVERY_SENTENCE,
  CONFIRM_RECOVERY_SENTENCE,
  IMPORT_WALLET
}

class WalletFlowState {
  const WalletFlowState({this.walletFlowStep, this.walletModel});

  final WalletFlowStep walletFlowStep;
  final WalletModel walletModel;

  WalletFlowState copyWith(
      {WalletFlowStep walletFlowStep, WalletModel walletModel}) {
    return WalletFlowState(
      walletFlowStep: walletFlowStep ?? this.walletFlowStep,
      walletModel: walletModel ?? this.walletModel,
    );
  }
}
