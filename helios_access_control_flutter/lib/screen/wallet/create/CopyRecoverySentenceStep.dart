import "package:build_context/build_context.dart";
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:helios_access_control_ui/screen/wallet/styles.dart';

import '../models.dart';
import '../widgets.dart';

class CopyRecoverySentenceStep extends StatefulWidget {
  @override
  _CopyRecoverySentenceStepState createState() =>
      _CopyRecoverySentenceStepState();
}

class _CopyRecoverySentenceStepState extends State<CopyRecoverySentenceStep> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.flow<WalletFlowState>().update(
              (walletFlowState) => walletFlowState.copyWith(
                  walletFlowStep: WalletFlowStep.CREATE_WALLET),
            );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: ListView(
                children: [
                  SizedBox(height: 50),
                  Text("Recovery sentence",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      )),
                  SizedBox(height: 25),
                  Text("Write or copy these words in a safe place"),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: MnemonicWidget(
                        pnemonicString: context
                            .flow<WalletFlowState>()
                            .state
                            .walletModel
                            .mnemonic),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: walletButtonStyle,
                      child: const Text('COPY'),
                      onPressed: _copyToClipboard,
                    ),
                  ),
                ],
              ),
            ),
          ),
          persistentFooterButtons: [
            ContinueWidget(onPressed: () {
              context.flow<WalletFlowState>().update((walletFlowState) {
                return walletFlowState.copyWith(
                  walletFlowStep: WalletFlowStep.CONFIRM_RECOVERY_SENTENCE,
                  walletModel:
                      context.flow<WalletFlowState>().state.walletModel,
                );
              });
            })
          ],
        ),
      ),
    );
  }

  String get _pnemonicString =>
      context.flow<WalletFlowState>().state.walletModel.mnemonic;

  void _copyToClipboard() async {
    await FlutterClipboard.copy(_pnemonicString);
    context.showSnackBar(
      SnackBar(
        content: Text("Copied to clipboard"),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
