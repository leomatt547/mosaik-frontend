import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/parent_registration_screen.dart';

Widget registerButton(context) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
      ),
      child: Text(
        "Create an Account",
        style: GoogleFonts.average(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: () {
        Route route = MaterialPageRoute(
            builder: (context) => const ParentRegistrationScreen());
        Navigator.push(context, route);
      },
    ),
  );
}
