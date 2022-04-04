import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/change_password_screen.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import '../constant.dart';
import 'package:mosaic/widgets/form.dart';

class AddBlockSiteScreen extends StatefulWidget {
  const AddBlockSiteScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<AddBlockSiteScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController urlController = TextEditingController();

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

  void onSave() {
    print(urlController.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    _getUserData();

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Add new site',
            style: GoogleFonts.average(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 196, 196, 196),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      commonForm(urlController, 'Name cannot be empty', 'Name'),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color.fromARGB(255, 196, 196, 196),
                              ),
                              child: Text(
                                "Apply",
                                style: GoogleFonts.average(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _showLoading();

                                  Map data = {
                                    'nama': urlController.text.toString(),
                                  };

                                  String body = json.encode(data);
                                  String url;
                                  if (storage.read('parent_id') != null) {
                                    url = API_URL +
                                        '/parents/${storage.read('parent_id')}';
                                  } else if (storage.read('child_id') != null) {
                                    url = API_URL +
                                        '/childs/${storage.read('child_id')}';
                                  } else {
                                    _showFailedPopup();
                                    return;
                                  }

                                  final response = await http.put(
                                      Uri.parse(url),
                                      body: body,
                                      encoding: Encoding.getByName('utf-8'),
                                      headers: {
                                        'Authorization': 'Bearer ' + getToken()
                                      });

                                  Navigator.pop(context); //pop dialog
                                  _updateProfile(response);
                                }
                              }))
                    ]))));
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
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
    } else {
      _showFailedPopup();
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

  void _showFailedPopup() {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Failed",
      desc: "Oops, something has gone wrong",
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

  Future<void> _getUserData() async {
    String url;

    if (storage.read('parent_id') != null) {
      url = API_URL + '/parents/${storage.read('parent_id')}';
    } else if (storage.read('child_id') != null) {
      url = API_URL + '/parents/${storage.read('child_id')}';
    } else {
      _showFailedPopup();
      return;
    }

    final response = await http.get(Uri.parse(url));

    var extractedData = json.decode(response.body);

    if (extractedData == null) {
      return;
    }

    if (extractedData['nama'] != null) {
      urlController.text = extractedData['nama'];
    }
  }
}
