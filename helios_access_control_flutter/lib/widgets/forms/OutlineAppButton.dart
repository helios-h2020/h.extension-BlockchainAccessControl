import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/di/DI.dart';

class OutlineAppButton extends StatelessWidget {
  const OutlineAppButton({
    Key key,
    this.label,
    this.onTap,
    this.disabled = false,
  }) : super(key: key);

  final String label;
  final Function onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      textColor: DI.primaryColor,
      borderSide: BorderSide(
        color: DI.primaryColor,
        style: BorderStyle.solid,
        width: 1
      ),
      disabledTextColor: DI.buttonDisabledTextColor,
      child: Text(label.toUpperCase()),
      onPressed: !disabled ? () => _onTap() : null,
    );
  }

  void _onTap() {
    if (!disabled) {
      onTap();
    }
  }
}
