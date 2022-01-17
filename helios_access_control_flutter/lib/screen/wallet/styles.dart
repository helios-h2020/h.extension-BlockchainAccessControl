import 'package:flutter/material.dart';
import 'package:helios_access_control_ui/di/DI.dart';

final walletButtonStyle = ElevatedButton.styleFrom(
  primary: DI.primaryColor,
  padding: EdgeInsets.zero,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);
