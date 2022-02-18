import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/browsing_screen.dart';
import 'register.dart';
import 'login.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
  // this allows us to access the TextField text
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onSelected(BuildContext context, int item) {
      switch (item) {
        case 0:
          print('New tab');
          break;
        case 1:
          print('go to history');
          break;
        case 2:
          print('go to Settings screen');
          break;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print("left");
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              print("right");
            },
            icon: const Icon(Icons.arrow_forward),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              print("home");
            },
            icon: const Icon(Icons.cottage_outlined),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              print("box");
            },
            icon: const Icon(Icons.check_box_outline_blank_outlined),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RegisterParentPage()),
              );
            },
            icon: const Icon(Icons.account_circle_outlined),
            color: Colors.black,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            child: PopupMenuButton<int>(
              color: Color.fromARGB(255, 196, 196, 196),
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      const SizedBox(width: 8),
                      Text(
                        'New tab',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.history),
                      const SizedBox(width: 8),
                      Text(
                        'History',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      const SizedBox(width: 8),
                      Text(
                        'Settings',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
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
            child: Flexible(
              flex: 6,
              child: TextFormField(
                controller: textFieldController,
                autocorrect: false,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2.0),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    fillColor: Color.fromARGB(255, 196, 196, 196),
                    filled: true),
                onFieldSubmitted: (term) {
                  _sendDataToSecondScreen(context);
                },
              ),
            ),
          ),
        ],
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
