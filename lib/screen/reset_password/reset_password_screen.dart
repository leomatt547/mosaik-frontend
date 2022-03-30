import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/widgets/form.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Forgot Password',
          style: GoogleFonts.average(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Enter your registered email below to receive password reset instruction',
                style: GoogleFonts.average(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.key,
                size: 96,
              ),
            ),
            emailForm(emailController, "Email address"),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 196, 196, 196),
                ),
                child: Text(
                  'Send',
                  style: GoogleFonts.average(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                  }
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
