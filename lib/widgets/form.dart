import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget commonForm(
    TextEditingController controller, String validationMsg, String labelText) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    child: TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMsg;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        errorStyle: GoogleFonts.average(
          fontWeight: FontWeight.w500,
        ),
      ),
      style: GoogleFonts.average(
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget passwordForm(
    TextEditingController passwordController,
    String validationMsg,
    String labelText,
    bool obscureText,
    void Function() setState) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMsg;
          }
          return null;
        },
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: setState,
          ),
          errorStyle: GoogleFonts.average(
            fontWeight: FontWeight.w500,
          ),
        ),
        style: GoogleFonts.average(
          fontWeight: FontWeight.w500,
        ),
      ));
}

Widget emailForm(emailController, String labelText) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    child: TextFormField(
      controller: emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email cannot be empty';
        }

        if (!EmailValidator.validate(value)) {
          return 'Invalid email';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        errorStyle: GoogleFonts.average(
          fontWeight: FontWeight.w500,
        ),
      ),
      style: GoogleFonts.average(
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
