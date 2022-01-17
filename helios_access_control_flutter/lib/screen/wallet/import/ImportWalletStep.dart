import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/model/wallet/Wallet.dart';
import 'package:helios_access_control_ui/screen/LoginScreen.dart';
import 'package:helios_access_control_ui/screen/wallet/widgets.dart';
import 'package:helios_access_control_ui/widgets/forms/AppTextField.dart';
import "package:build_context/build_context.dart";

import '../models.dart';
import '../styles.dart';

class ImportWalletStep extends StatefulWidget {
  @override
  _ImportWalletStepState createState() => _ImportWalletStepState();
}

class _ImportWalletStepState extends State<ImportWalletStep> {
  String _mnemonic = "";

  final _formKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  String _passphrase = "";

  @override
  void initState() {
    super.initState();
    myController.addListener(() {
      _mnemonic = myController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.flow<WalletFlowState>().update(
              (walletFlowState) => walletFlowState.copyWith(
                  walletFlowStep: WalletFlowStep.SHOW_WELCOME),
            );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Listener(
            onPointerDown: (_) {
              context.closeKeyboard();
            },
            child: Form(
              key: _formKey,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  child: ListView(
                    children: [
                      SizedBox(height: 50),
                      Text("Import Wallet",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          )),
                      SizedBox(height: 8),
                      Text("Put your passphrase to import the wallet"),
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
                      SizedBox(height: 25),
                      AppTextField(
                        controller: myController,
                        defaultValue: null,
                        label: "Recovery Sentence",
                        obscureText: false,
                        minLines: 5,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onSaved: (String value) {
                          _mnemonic = value;
                        },
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return "Mandatory field";
                          }
                          return null;
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: walletButtonStyle,
                          child: const Text('PASTE FROM CLIPBOARD'),
                          onPressed: () async {
                            String value = await _pasteFromClipboard();
                            myController.text = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          persistentFooterButtons: [
            ContinueWidget(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _importWallet();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<String> _pasteFromClipboard() async {
    return FlutterClipboard.paste();
  }

  Future<void> _importWallet() async {
    WalletModel wallet =
        WalletModel(passphrase: _passphrase, mnemonic: _mnemonic);
    final credentialsResponse =
        await DI.heliosWalletRepository.getWalletCredentials(
      pass: wallet.passphrase,
      mnemonic: wallet.mnemonic,
    );
    if (credentialsResponse.success) {
      wallet.setCredentials(credentialsResponse);
      await DI.heliosWalletRepository
          .saveWalletCredentials(walletModel: wallet);
      context.showSnackBar(
        SnackBar(
          content: Text("Wallet imported"),
        ),
      );
      Get.offAll(LoginScreen());
      return false;
    }
  }
}
