import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/parent_registration_screen.dart';

Widget registerButton(context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 196, 196, 196),
      ),
      child: Text(
        "Create an Account",
        style: GoogleFonts.average(
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: () {
        Route route =
            MaterialPageRoute(builder: (context) => ParentRegistrationScreen());
        Navigator.push(context, route);
      },
    ),
  );
}
