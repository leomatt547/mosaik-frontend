import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  void onSave() {
    print(oldPasswordController.text.toString());
    print(newPasswordController.text.toString());
    print(confirmNewPasswordController.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Old password';
                    }
                    return null;
                  },
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Old Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter password';
                    }
                    return null;
                  },
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter confirm password';
                    }
                    return null;
                  },
                  controller: confirmNewPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 196, 196, 196),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                onPressed: () {
                  onSave();
                },
              ),
            ),
          ])),
    );
  }
}
