import 'package:flutter/material.dart';
import 'package:mosaic/screen/splash.dart';
// ignore: unused_import
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Cannot implement async in android
  // await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext ctx) {
    return const MaterialApp(home: Splash());
  }
}
