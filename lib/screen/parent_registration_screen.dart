import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/login.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:mosaic/widgets/form.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import '../constant.dart';


class ParentRegistrationScreen extends StatefulWidget {
  const ParentRegistrationScreen({Key? key}) : super(key: key);

  @override
  _ParentRegistrationScreenState createState() => _ParentRegistrationScreenState();
}

class _ParentRegistrationScreenState extends State<ParentRegistrationScreen> {

  static final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var bodyProgress = Container(
    decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0)
    ),
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
            child: Text(
                "Processing...",
                style: GoogleFonts.average(
                  fontWeight: FontWeight.w700,
                )
            ),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      resizeToAvoidBottomInset: false,
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
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Welcome',
                    style: GoogleFonts.average(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                nameForm(nameController, "Name"),
                emailForm(emailController, "Your Email"),
                passwordForm(passwordController),
                confirmPasswordForm(
                    confirmPasswordController, passwordController),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 196, 196, 196),
                  ),
                  child: Text(
                    "Create Account",
                    style: GoogleFonts.average(
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                    ),
                  ),
                  onPressed: () async {
                    Map data = {
                      'nama': nameController.text.toString(),
                      'email': emailController.text.toString(),
                      'password': passwordController.text.toString(),
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
                      Uri.parse(API_URL + "/parents"),
                      body: body,
                      encoding: Encoding.getByName('utf-8'),
                    );

                    Navigator.pop(context); //pop dia
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
        desc: "Your account has been successfully created",
        buttons: [
          DialogButton(
            child: const Text(
              "OK",
              style:
              TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(
                  builder: (context) => LoginPage());
              Navigator.push(context, route);
            },
          )
        ],
      ).show();
    }
  }

}
