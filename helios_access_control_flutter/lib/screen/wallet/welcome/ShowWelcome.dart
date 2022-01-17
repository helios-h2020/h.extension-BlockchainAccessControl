import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/di/DI.dart';

import '../models.dart';
import 'package:flow_builder/flow_builder.dart';

final _buttonStyle = ElevatedButton.styleFrom(
  primary: DI.primaryColor,
  padding: EdgeInsets.zero,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

class ShowWelcome extends StatefulWidget {
  @override
  _ShowWelcomeState createState() => _ShowWelcomeState();
}

class _ShowWelcomeState extends State<ShowWelcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 75),
              Image.asset(
                "assets/img/img_splash.png",
                width: 423,
                height: 317,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: _buttonStyle,
                  child: const Text('CREATE NEW WALLET'),
                  onPressed: _createNewWalletPressed,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: _buttonStyle,
                  child: const Text(
                    'IMPORT MY WALLET',
                    textAlign: TextAlign.start,
                  ),
                  onPressed: _importExistingWalletPressed,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _createNewWalletPressed() {
    context.flow<WalletFlowState>().update(
          (walletFlowState) => walletFlowState.copyWith(
              walletFlowStep: WalletFlowStep.CREATE_WALLET),
        );
  }

  void _importExistingWalletPressed() {
    context.flow<WalletFlowState>().update(
          (walletFlowState) => walletFlowState.copyWith(
              walletFlowStep: WalletFlowStep.IMPORT_WALLET),
        );
  }
}
