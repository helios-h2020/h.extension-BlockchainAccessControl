import 'package:flutter/material.dart';
import 'package:wallet_example/di/DI.dart';
import 'package:wallet_example/model/models.dart';
import 'package:wallet_example/widgets/forms/AppTextField.dart';
import 'package:accordion/accordion.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKeyState = GlobalKey<FormState>();

  WalletModel _currentWallet = WalletModel();

  String _passphrase = "";

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
                Visibility(
                    visible: _currentWallet.isValid(),
                    child: LatestWalletSection(wallet: _currentWallet)),
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

      final credentials = await DI.heliosWalletRepository.getWalletCredentials(
        pass: wallet.passphrase,
        mnemonic: wallet.mnemonic,
      );
      wallet.setCredentials(credentials.address, credentials.privateKey);

      _currentWallet = wallet;
      setState(() {});
    }
  }
}

class LatestWalletSection extends StatelessWidget {
  final WalletModel wallet;

  const LatestWalletSection({Key key, this.wallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AccordionSection> addressListWidgets = getAddressListWidgets();
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.wallet_giftcard),
              title: const Text('Latest wallet created'),
            ),
            SizedBox(height: 10),
            Text(
              "Mnemonic",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              children: [
                Text(wallet.mnemonic),
              ],
            ),
            SizedBox(
              height: 200,
              child: Accordion(
                maxOpenSections: 1,
                headerTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
                leftIcon: Icon(Icons.public, color: Colors.white),
                children: addressListWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AccordionSection> getAddressListWidgets() {
    List<AccordionSection> widgets = [];

    Widget addressWidget = AccordionSection(
        isOpen: true,
        headerText: 'Credentials',
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Address",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(wallet.credentials.address),
            SizedBox(height: 8),
            Text(
              "Private key",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(wallet.credentials.privateKey),
          ],
        ));
    widgets.add(addressWidget);
    return widgets;
  }
}
