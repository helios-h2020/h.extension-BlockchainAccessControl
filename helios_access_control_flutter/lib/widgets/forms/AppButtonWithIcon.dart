import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/di/DI.dart';

class AppButtonWithIcon extends StatelessWidget {
  const AppButtonWithIcon({
    Key key,
    this.label,
    this.icon,
    this.onTap,
    this.disabled = false,
  }) : super(key: key);

  final String label;
  final Icon icon;
  final Function onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton.icon(
        label: Text(label.toUpperCase()),
        icon: icon,
        color: DI.buttonBgColor,
        disabledColor: DI.buttonDisabledBgColor,
        textColor: DI.buttonTextColor,
        disabledTextColor: DI.buttonDisabledTextColor,
        onPressed: !disabled ? () => _onTap() : null,
      ),
    );
  }

  void _onTap() {
    if (!disabled) {
      onTap();
    }
  }
}
