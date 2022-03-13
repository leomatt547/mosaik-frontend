import 'package:flutter/material.dart';
import 'package:mosaic/utils/response_message.dart';

Widget nameForm(nameController, labelForm) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return responseMessage['emptyForm']['name'];
          }
          return null;
        },
        controller: nameController,
        decoration: InputDecoration(
          labelText: labelForm,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        )),
  );
}

Widget passwordForm(passwordController) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return responseMessage['emptyForm']['password'];
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        )),
  );
}

Widget confirmPasswordForm(confirmPasswordController, passwordController) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return responseMessage['emptyForm']['confirmPassword'];
          }

          if (value != passwordController.text) {
            return responseMessage['notMatchForm']['confirmPassword'];
          }

          return null;
        },
        controller: confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        )),
  );
}

Widget emailForm(emailController, labelForm) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
    child: TextFormField(
        controller: emailController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return responseMessage['emptyForm']['email'];
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: labelForm,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        )),
  );
}
