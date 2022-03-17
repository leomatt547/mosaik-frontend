import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:mosaic/widgets/form.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';

class ChildRegistration extends StatelessWidget {
  ChildRegistration({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Child Account Registration',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                nameForm(nameController, "Child's Name"),
                emailForm(emailController, "Child's Email"),
                passwordForm(passwordController),
                confirmPasswordForm(
                    confirmPasswordController, passwordController),
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
                        headers: {'Authorization': 'Bearer ' + getToken()});

                    if (response.statusCode == 201) {
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "Success",
                        desc: "Child account has been successfully created",
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "Okay",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (context) => LandingPage());
                              Navigator.push(context, route);
                            },
                          )
                        ],
                      ).show();
                    } else {
                      Map<String, dynamic> responseBody =
                          jsonDecode(response.body);
                      String errorMessage = responseBody["error"];
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: errorMessage,
                        buttons: [
                          DialogButton(
                            child: const Text(
                              "Okay",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
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
