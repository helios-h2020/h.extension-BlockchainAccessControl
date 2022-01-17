import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:helios_access_control_ui/di/DI.dart';

class AppButton extends StatelessWidget {
  const AppButton({
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
    return RaisedButton(
      color: DI.buttonBgColor,
      disabledColor: DI.buttonDisabledBgColor,
      textColor: DI.buttonTextColor,
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

class AppButtonWithDebounce extends StatelessWidget {
  AppButtonWithDebounce({
    Key key,
    this.label,
    this.onTap,
    this.disabled = false,
  }) : super(key: key);

  final String label;
  final Function onTap;
  final bool disabled;

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: DI.buttonBgColor,
      disabledColor: DI.buttonDisabledBgColor,
      textColor: DI.buttonTextColor,
      disabledTextColor: DI.buttonDisabledTextColor,
      child: Text(label.toUpperCase()),
      onPressed: !disabled ? () => _debouncer.run(() => _onTap()) : null,
    );
  }

  void _onTap() {
    if (!disabled) {
      onTap();
    }
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
