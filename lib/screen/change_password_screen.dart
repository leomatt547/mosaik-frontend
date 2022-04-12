import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/widgets/form.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constant.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureOldPw = true;
  bool _obscureNewPw = true;
  bool _obscureConfirmNewPw = true;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

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

  void _oldPwToggle() {
    setState(() {
      _obscureOldPw = !_obscureOldPw;
    });
  }

  void _newPwToggle() {
    setState(() {
      _obscureNewPw = !_obscureNewPw;
    });
  }

  void _confirmNewPwToggle() {
    setState(() {
      _obscureConfirmNewPw = !_obscureConfirmNewPw;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Change Password',
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    passwordForm(
                        oldPasswordController,
                        'Old Password cannot be empty',
                        'Old Password',
                        _obscureOldPw,
                        _oldPwToggle),
                    passwordForm(
                        newPasswordController,
                        'New Password cannot be empty',
                        'New Password',
                        _obscureNewPw,
                        _newPwToggle),
                    passwordForm(
                        confirmNewPasswordController,
                        'Confirm New Password cannot be empty',
                        'Confirm New Password',
                        _obscureConfirmNewPw,
                        _confirmNewPwToggle),
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
                            _showLoading();
                            String oldPw =
                                oldPasswordController.text.toString();
                            String newPw =
                                newPasswordController.text.toString();
                            String confirmNewPw =
                                confirmNewPasswordController.text.toString();

                            if (newPw != confirmNewPw) {
                              Navigator.pop(context);
                              _showFailedPopup("New password did not match");
                              return;
                            }

                            Map data = {
                              'oldPassword': oldPw,
                              'newPassword': newPw,
                            };

                            String body = json.encode(data);
                            String url;
                            if (storage.read('parent_id') != null) {
                              url = API_URL +
                                  '/parents/password/${storage.read('parent_id')}';
                            } else if (storage.read('child_id') != null) {
                              url = API_URL +
                                  '/childs/password/${storage.read('child_id')}';
                            } else {
                              _showFailedPopup("");
                              return;
                            }

                            final response = await http.post(Uri.parse(url),
                                body: body,
                                encoding: Encoding.getByName('utf-8'),
                                headers: {
                                  'Authorization': 'Bearer ' + getToken()
                                });
                            Navigator.pop(context); //pop dialog
                            _changePassword(response);
                          }
                        },
                      ),
                    ),
                  ])),
        ));
  }

  void _changePassword(response) {
    if (response.statusCode == 200) {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Success",
        desc: "Your password has been successfully changed",
        buttons: [
          DialogButton(
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              })
        ],
      ).show();
    } else {
      _showFailedPopup("");
    }
  }

  void _showLoading() {
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
  }

  void _showFailedPopup(String desc) {
    if (desc.isEmpty) {
      desc = "Oops, something has gone wrong";
    }

    Alert(
      context: context,
      type: AlertType.error,
      title: "Failed",
      desc: desc,
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
