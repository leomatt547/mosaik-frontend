import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:mosaic/widgets/button.dart';
import 'package:mosaic/widgets/form.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Hi,',
                    style: TextStyle(fontSize: 28),
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

                        // TODO: API Call
                        String token = 'token';

                        // Validate data (hardcode)
                        if (email != 'mark@gmail.com' ||
                            password != 'password') {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Credential is invalid",
                            desc: "Your email or password is wrong",
                          ).show();
                        } else {
                          storage.write('token', token);
                          Route route = MaterialPageRoute(
                              builder: (context) => const LandingPage());
                          Navigator.push(context, route);
                        }
                      }
                    },
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
