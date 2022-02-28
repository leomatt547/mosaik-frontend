import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/utils/jwt_helper.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:mosaic/widgets/button.dart';
import 'package:mosaic/widgets/form.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.only(
                bottom: 100, top: 80, left: 30, right: 30),
            padding: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    blurRadius: 5, color: Colors.black, offset: Offset(0, 3))
              ],
              border: Border.all(),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Hi, let\'s start browsing',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                emailForm(emailController),
                passwordForm(passwordController),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 196, 196, 196),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String email = emailController.text.toString();
                        String password = passwordController.text.toString();

                        Map data = {
                          'email': email,
                          'password': password,
                        };

                        String body = json.encode(data);
                        final response = await http.post(
                          Uri.parse(API_URL + "/login"),
                          body: body,
                          encoding: Encoding.getByName('utf-8'),
                        );

                        if (response.statusCode == 200) {
                          String jwt = response.body.replaceAll('"', '').trim();
                          storage.write('token', jwt);

                          // Extract parent_id from token
                          Map<String, dynamic> jwtPayload =
                              JwtHelper.parseJwtPayLoad(jwt);
                          storage.write('parent_id', jwtPayload['parent_id']);

                          Route route = MaterialPageRoute(
                              builder: (context) => LandingPage());
                          Navigator.push(context, route);
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();
                        }
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    '------ OR ------',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                registerButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
