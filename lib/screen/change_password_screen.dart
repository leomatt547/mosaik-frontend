import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/widgets/form.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  bool _obscureOldPw = true;
  bool _obscureNewPw = true;
  bool _obscureConfirmNewPw = true;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

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

  void onSave() {
    print(oldPasswordController.text.toString());
    print(newPasswordController.text.toString());
    print(confirmNewPasswordController.text.toString());
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                passwordForm(oldPasswordController, 'Old Password cannot be empty', 'Old Password', _obscureOldPw, _oldPwToggle),
            passwordForm(newPasswordController, 'New Password cannot be empty', 'New Password', _obscureNewPw, _newPwToggle),
            passwordForm(confirmNewPasswordController, 'Confirm New Password cannot be empty', 'Confirm New Password', _obscureConfirmNewPw, _confirmNewPwToggle),
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
                onPressed: () {
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

                  Navigator.pop(context); //pop dialog
                  onSave();
                },
              ),
            ),
          ])),
    );
  }
}
