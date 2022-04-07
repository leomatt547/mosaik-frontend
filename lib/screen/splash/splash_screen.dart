import 'package:flutter/material.dart';
import 'package:mosaic/screen/login/login_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/WASplashScreen';

  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light);
    await Future.delayed(Duration(seconds: 3));
    if (mounted) finish(context);
    LoginScreen().launch(context, isNewTask: true);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.white, statusBarIconBrightness: Brightness.dark);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: Colors.white,
              size: 100,
            ).center(),
            // Image.asset(
            //   'assets/app_logo.png',
            //   color: Colors.white,
            //   fit: BoxFit.cover,
            //   height: 100,
            //   width: 100,
            // ).center(),
          ],
        ),
      ),
    );
  }
}
