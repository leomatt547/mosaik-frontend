import 'package:flutter/material.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/screen/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext ctx) {
    return MaterialApp(home: Splash());
  }
}
