import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/browsing_screen.dart';
import 'package:mosaic/widgets/appbar.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search,
                  size: 64,
                ),
                Text('Mosaik',
                    style: GoogleFonts.average(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        backgroundColor: Colors.white))
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: textFieldController,
                      autocorrect: false,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          fillColor: Color.fromARGB(255, 196, 196, 196),
                          filled: true),
                      onFieldSubmitted: (term) {
                        _sendDataToSecondScreen(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendDataToSecondScreen(BuildContext context) {
    String textToSend = textFieldController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrowsingScreen(textToSend),
        ));
  }
}
