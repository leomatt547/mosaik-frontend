import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/change_password_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constant.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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

  void onSave() {
    print(nameController.text.toString());
    print(emailController.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Update Profile',
          style: GoogleFonts.average(
            color: Colors.black,
            fontWeight: FontWeight.w700,
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
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 20, right: 20),
                  child: Image.asset('assets/img/profile-picture.png',
                      height: 150, fit: BoxFit.fill),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 20, right: 20),
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
                  padding: const EdgeInsets.only(
                      bottom: 10, left: 20, right: 20),
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
                  padding: const EdgeInsets.only(
                      bottom: 5, left: 20, right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 196, 196, 196),
                    ),
                    child: Text(
                      "Change Password",
                      style: GoogleFonts.average(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      Route route =
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen());
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
                    child: Text(
                      "Save",
                      style: GoogleFonts.average(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Map data = {
                          'nama': nameController.text.toString(),
                          'email': emailController.text.toString(),
                        };

                        String body = json.encode(data);
                        String url = API_URL +
                            '/parents/${storage.read('parent_id')}';

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

                        final response = await http.put(
                            Uri.parse(url),
                            body: body,
                            encoding: Encoding.getByName('utf-8'),
                            headers: {
                              'Authorization': 'Bearer ' + getToken()
                            }
                        );

                        Navigator.pop(context); //pop dialog
                        _updateProfile(response);
                      }
                    },
                  ),
                ),
              ])),
    );
  }

  void _updateProfile(response) {
    if (response.statusCode == 200) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Success",
        desc: "Your profile has been successfully changed",
        buttons: [
          DialogButton(
            child: const Text(
              "OK",
              style:
              TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
    } else {

      Alert(
        context: context,
        type: AlertType.error,
        title: "Failed",
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
  }
}
