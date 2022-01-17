import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/wallet/Wallet.dart';
import 'package:helios_access_control_ui/widgets/forms/AppTextField.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:wallet/wallet.dart';

import '../models.dart';

class CreateWalletStep extends StatefulWidget {
  const CreateWalletStep({Key key}) : super(key: key);

  @override
  _CreateWalletStepState createState() => _CreateWalletStepState();
}

class _CreateWalletStepState extends State<CreateWalletStep> {
  final _formKeyState = GlobalKey<FormState>();

  String _passphrase = "";

  WalletModel _currentWallet = WalletModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Helios Wallet Demo'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyState,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Put your passphrase to create a wallet with 1 address"),
                SizedBox(height: 8),
                AppTextField(
                  label: "Passphrase",
                  onSaved: (value) {
                    if (value != null) {
                      _passphrase = value;
                    } else {
                      _passphrase = "";
                    }
                  },
                  validator: (String value) {
                    return "";
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      child: const Text("Create wallet"),
                      onPressed: () async {
                        if (_formKeyState.currentState.validate()) {
                          _formKeyState.currentState.save();
                          _createWallet();
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createWallet() async {
    final response =
        await DI.heliosWalletRepository.createWallet(pass: _passphrase);
    if (response.success) {
      WalletModel wallet =
          WalletModel(passphrase: _passphrase, mnemonic: response.mnemonic);

      final WalletCredentialsResponse credentials = await DI.heliosWalletRepository.getWalletCredentials(
        pass: wallet.passphrase,
        mnemonic: wallet.mnemonic,
      );
      wallet.setCredentials(credentials);
      _currentWallet = wallet;
      context.flow<WalletFlowState>().update(
            (walletFlowState) => walletFlowState.copyWith(
                walletFlowStep: WalletFlowStep.COPY_RECOVERY_SENTENCE,
                walletModel: _currentWallet),
          );
      return false;
    }
  }
}
