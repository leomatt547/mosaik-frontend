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
  String _blockType = 'whitelist';

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
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          controller: urlController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This form can't be empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Url",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            errorStyle: GoogleFonts.average(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: GoogleFonts.average(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                      value: 'whitelist',
                                      groupValue: _blockType,
                                      onChanged: (String? val) {
                                        setState(() {
                                          _blockType = val!;
                                        });
                                      }),
                                  const Expanded(child: Text('Whitelist'))
                                ],
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                      value: 'blacklist',
                                      groupValue: _blockType,
                                      onChanged: (String? val) {
                                        setState(() {
                                          _blockType = val!;
                                        });
                                      }),
                                  const Expanded(
                                    child: Text('Blacklist'),
                                  )
                                ],
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    const Color.fromARGB(255, 196, 196, 196),
                              ),
                              child: Text(
                                "Add",
                                style: GoogleFonts.average(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // _showLoading();

                                  Map data = {
                                    'url': urlController.text.toString(),
                                    'type': _blockType,
                                  };
                                  // ignore: avoid_print
                                  print(data);

                                  // String body = json.encode(data);
                                  // String url;
                                  // if (storage.read('parent_id') != null) {
                                  //   url = API_URL +
                                  //       '/parents/${storage.read('parent_id')}';
                                  // } else if (storage.read('child_id') != null) {
                                  //   url = API_URL +
                                  //       '/childs/${storage.read('child_id')}';
                                  // } else {
                                  //   _showFailedPopup();
                                  //   return;
                                  // }

                                  // final response = await http.put(
                                  //     Uri.parse(url),
                                  //     body: body,
                                  //     encoding: Encoding.getByName('utf-8'),
                                  //     headers: {
                                  //       'Authorization': 'Bearer ' + getToken()
                                  //     });

                                  // Navigator.pop(context); //pop dialog
                                }
                              })),
                    ]))));
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
}
