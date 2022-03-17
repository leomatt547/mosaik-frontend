import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget passwordForm(passwordController) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter password';
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        style: GoogleFonts.average(
          fontWeight: FontWeight.w500,
        ),),
  );
}

Widget emailForm(emailController) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    child: TextFormField(
        controller: emailController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter email';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Your Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        style: GoogleFonts.average(
          fontWeight: FontWeight.w500,
        ),),
  );
}
