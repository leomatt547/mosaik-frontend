import 'package:flutter/material.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/screen/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Cannot implement async in android
  // await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext ctx) {
    return MaterialApp(home: Splash());
  }
}
