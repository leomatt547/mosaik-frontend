import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart';
import 'login.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      ),
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
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    fillColor: Color.fromARGB(255, 196, 196, 196),
                    filled: true),
              )),
        ],
      ),
    );
  }
}
