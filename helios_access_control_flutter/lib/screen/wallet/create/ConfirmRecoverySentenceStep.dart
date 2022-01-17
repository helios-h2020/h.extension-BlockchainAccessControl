import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:get/get.dart';
import 'package:helios_access_control_ui/di/DI.dart';
import 'package:helios_access_control_ui/screen/LoginScreen.dart';
import 'package:helios_access_control_ui/screen/wallet/widgets.dart';
import 'package:helios_access_control_ui/widgets/forms/AppTextField.dart';
import "package:build_context/build_context.dart";

import '../models.dart';
import '../styles.dart';

class ConfirmRecoverySentenceStep extends StatefulWidget {
  @override
  _ConfirmRecoverySentenceStepState createState() =>
      _ConfirmRecoverySentenceStepState();
}

class _ConfirmRecoverySentenceStepState
    extends State<ConfirmRecoverySentenceStep> {
  String _pnemonic = "";

  final _formKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myController.addListener(() {
      _pnemonic = myController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.flow<WalletFlowState>().update(
              (walletFlowState) => walletFlowState.copyWith(
                  walletFlowStep: WalletFlowStep.COPY_RECOVERY_SENTENCE),
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
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: ListView(
                    children: [
                      SizedBox(height: 50),
                      Text("Confirm recovery sentence",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          )),
                      SizedBox(height: 25),
                      Text("Write your recovery sentence"),
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
                          _pnemonic = value;
                        },
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return "Mandatory field";
                          }
                          if (_initialPnemonic != value) {
                            return "Invalid pnemonic";
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
                if (_pnemonic == _initialPnemonic) {
                  await DI.heliosWalletRepository.saveWalletCredentials(
                      walletModel:
                          context.flow<WalletFlowState>().state.walletModel);
                  context.showSnackBar(
                    SnackBar(
                      content: Text("Wallet created"),
                    ),
                  );
                  Get.offAll(LoginScreen());
                } else {
                  context.showSnackBar(
                    SnackBar(
                      content: Text("Invalid pnemonic"),
                      duration: Duration(milliseconds: 1500),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String get _initialPnemonic {
    return context.flow<WalletFlowState>().state.walletModel.mnemonic;
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<String> _pasteFromClipboard() async {
    return FlutterClipboard.paste();
  }
}
