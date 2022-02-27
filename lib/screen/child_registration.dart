import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

class ChildRegistration extends StatelessWidget {
  ChildRegistration({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Child Account Registration',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Child\'s name cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Child's Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Child\'s email cannot be empty';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Email is invalid';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Child's Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: TextFormField(
                    controller: confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password cannot be empty';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      )),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 196, 196, 196),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    } else {
                      return;
                    }
                    Map data = {
                      'nama': nameController.text.toString(),
                      'email': emailController.text.toString(),
                      'password': passwordController.text.toString(),
                      'parent_id': storage.read('parent_id'),
                    };

                    String body = json.encode(data);
                    final response = await http.post(
                      Uri.parse(API_URL + "/childs"),
                      body: body,
                      encoding: Encoding.getByName('utf-8'),
                      headers: {
                        'Authorization': 'Bearer ' + getToken()
                      }
                    );

                    if (response.statusCode == 201) {
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Success",
                        desc: "Child account has been successfully created",
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => const LandingPage());
                              Navigator.push(context, route);
                            },
                          )
                        ],
                      ).show();
                    } else {
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Registration Failed",
                        desc: "Oops, something has gone wrong",
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "CLOSE",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ).show();
                    }
                    return;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
