import 'package:flutter/material.dart';

import '../screen/parent_registration.dart';

Widget registerButton(context) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 196, 196, 196),
      ),
      child: const Text(
        "Create an Account",
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      onPressed: () {
        Route route =
            MaterialPageRoute(builder: (context) => ParentRegistration());
        Navigator.push(context, route);
      },
    ),
  );
}
