import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(
                  labelText: "Your Email (Child)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                )),
                TextFormField(
                    decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                )),
                TextFormField(
                    decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                )),
                TextFormField(
                    decoration: InputDecoration(
                  labelText: "Parent Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 196, 196, 196),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
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
