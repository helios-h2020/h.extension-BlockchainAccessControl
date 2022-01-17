import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helios_access_control_ui/screen/SplashScreen.dart';
import 'package:overlay_support/overlay_support.dart';

import 'di/DI.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyApp.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  static init() async {
    await Firebase.initializeApp();
    DI().initialize();
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(
      Color(0xFFEAEDED),
    );
    return OverlaySupport(
      child: GetMaterialApp(
        title: 'Helios access control',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.robotoTextTheme()
        ),
        home: SplashScreen(),
      ),
    );
  }
}
