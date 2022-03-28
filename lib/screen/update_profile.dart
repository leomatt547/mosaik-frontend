import 'package:flutter/material.dart';
import 'package:mosaic/screen/change_password.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void onSave() {
    print(nameController.text.toString());
    print(emailController.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Update Profile',
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
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: Image.asset('assets/img/profile-picture.png',
                  height: 150, fit: BoxFit.fill),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter name';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter email';
                    }
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Your Email (Parent)",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 196, 196, 196),
                ),
                child: const Text(
                  "Change Password",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                onPressed: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => ChangePassword());
                  Navigator.push(context, route);
                },
              ),
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
