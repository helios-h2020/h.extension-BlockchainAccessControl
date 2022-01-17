import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/screen/wallet/import/ImportWalletStep.dart';

import 'create/ConfirmRecoverySentenceStep.dart';
import 'create/CopyRecoverySentenceStep.dart';
import 'create/CreateWalletStep.dart';
import 'welcome/ShowWelcome.dart';
import 'models.dart';

class WalletFlowScreen extends StatelessWidget {
  const WalletFlowScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlowBuilder<WalletFlowState>(
      state: const WalletFlowState(walletFlowStep: WalletFlowStep.SHOW_WELCOME),
      onGeneratePages: (walletFlowState, pages) {
        return [
          if (walletFlowState.walletFlowStep == WalletFlowStep.SHOW_WELCOME)
            MaterialPage(child: ShowWelcome()),
          if (walletFlowState.walletFlowStep == WalletFlowStep.CREATE_WALLET)
            MaterialPage(child: CreateWalletStep()),
          if (walletFlowState.walletFlowStep ==
              WalletFlowStep.COPY_RECOVERY_SENTENCE)
            MaterialPage(child: CopyRecoverySentenceStep()),
          if (walletFlowState.walletFlowStep ==
              WalletFlowStep.CONFIRM_RECOVERY_SENTENCE)
            MaterialPage(child: ConfirmRecoverySentenceStep()),
          if (walletFlowState.walletFlowStep == WalletFlowStep.IMPORT_WALLET)
            MaterialPage(child: ImportWalletStep()),
        ];
      },
    );
  }
}
