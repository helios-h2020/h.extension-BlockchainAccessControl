import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/di/DI.dart';

class MnemonicWidget extends StatelessWidget {
  final String pnemonicString;
  List<String> _words;

  MnemonicWidget({Key key, this.pnemonicString}) : super(key: key) {
    _words = pnemonicString.split(" ");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: _words.length,
        itemBuilder: (context, index) {
          return Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(_words[index])));
        });
  }
}

class ContinueWidget extends StatelessWidget {
  final Function onPressed;

  const ContinueWidget({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: DI.createResourceButtonColor,
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          "CONTINUE",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: DI.robotoRegular,
          ),
        ),
      ),
    );
  }
}