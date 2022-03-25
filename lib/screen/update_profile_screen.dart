import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/change_password_screen.dart';
import 'package:mosaic/widgets/form.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
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
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: Image.asset('assets/img/profile-picture.png',
                  height: 150, fit: BoxFit.fill),
            ),
            commonForm(nameController, 'Name cannot be empty', 'Name'),
            emailForm(emailController, 'Email'),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 20, right: 20),
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
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen());
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
