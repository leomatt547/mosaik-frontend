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
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            child: Text("Logging in...",
                style: GoogleFonts.average(
                  fontWeight: FontWeight.w700,
                )),
          ),
        ),
      ],
    ),
  );

  void _passwordToggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Hi, let\'s start browsing',
                      style: GoogleFonts.average(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                emailForm(emailController, 'Your Email'),
                passwordForm(passwordController, 'Password cannot be empty',
                    'Password', _obscureText, _passwordToggle),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 196, 196, 196),
                    ),
                    child: Text(
                      "Login",
                      style: GoogleFonts.average(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
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
                          Uri.parse(API_URL + "/login"),
                          body: body,
                          encoding: Encoding.getByName('utf-8'),
                        );

                        Navigator.pop(context); //pop dialog
                        _login(response);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'OR',
                    style: GoogleFonts.average(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
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

  void _login(response) {
    if (response.statusCode == 200) {
      String jwt = response.body.replaceAll('"', '').trim();
      storage.write('token', jwt);

      // Extract parent_id from token
      Map<String, dynamic> jwtPayload = JwtHelper.parseJwtPayLoad(jwt);
      storage.write('parent_id', jwtPayload['parent_id']);
      storage.write('child_id', jwtPayload['child_id']);
      Route route = MaterialPageRoute(builder: (context) => LandingPage());
      Navigator.push(context, route);
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Credential is invalid",
        desc: "Your email or password is wrong",
        buttons: [
          DialogButton(
            child: const Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }
}
