import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/browsing_screen.dart';
import 'package:mosaic/screen/landing_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToLanding();
  }

  _navigateToLanding() async {
    await Future.delayed(Duration(seconds: 4));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LandingPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 64,
              ),
              Text('Mosaik',
                  style: GoogleFonts.average(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      backgroundColor: Colors.white))
            ],
          ),
        ],
      ),
    );
  }
}
