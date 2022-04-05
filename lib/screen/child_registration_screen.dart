import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

class ChildRegistrationScreen extends StatefulWidget {
  const ChildRegistrationScreen({Key? key}) : super(key: key);

  @override
  _ChildRegistrationScreenState createState() =>
      _ChildRegistrationScreenState();
}

class _ChildRegistrationScreenState extends State<ChildRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var bodyProgress = Container(
    decoration: BoxDecoration(
        color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
    width: 300.0,
    height: 200.0,
    alignment: AlignmentDirectional.center,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Center(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(
              value: null,
              strokeWidth: 7.0,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25.0),
          child: Center(
            child: Text("Processing...",
                style: GoogleFonts.average(
                  fontWeight: FontWeight.w700,
                )),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 5, color: Colors.black, offset: Offset(0, 3))
              ],
              border: Border.all(),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            padding: const EdgeInsets.only(bottom: 10),
            margin:
                const EdgeInsets.only(bottom: 30, top: 60, left: 30, right: 30),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Child Account Registration',
                    style: GoogleFonts.average(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
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
                  child: Text(
                    "Create Account",
                    style: GoogleFonts.average(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
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

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: bodyProgress,
                          contentPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                        );
                      },
                    );

                    final response = await http.post(
                        Uri.parse(API_URL + "/childs"),
                        body: body,
                        encoding: Encoding.getByName('utf-8'),
                        headers: {'Authorization': 'Bearer ' + getToken()});

                    Navigator.pop(context); //pop dialog
                    _register(response);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register(response) {
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
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (context) => LandingPage());
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
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
    }
  }
}
