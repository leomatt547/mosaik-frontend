import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/child_registration.dart';
import 'package:mosaic/screen/history_screen.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/screen/login.dart';
import 'package:mosaic/screen/update_profile.dart';
import 'package:flutter/gestures.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BrowsingScreen extends StatefulWidget {
  final String text;
  const BrowsingScreen(this.text);
  @override
  _BrowsingScreenState createState() => _BrowsingScreenState();
}

class _BrowsingScreenState extends State<BrowsingScreen> {
  late WebViewController _webViewController;
  TextEditingController _teController = new TextEditingController();
  bool showLoading = false;

  void updateLoading(bool ls) {
    this.setState(() {
      showLoading = ls;
    });
  }

  @override
  Widget build(BuildContext context) {
    void onSelectedMoreOptions(BuildContext context, int item) {
      switch (item) {
        case 0:
          print('New tab');
          break;
        case 1:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const HistoryScreen()),
          );
          break;
        case 2:
          print('Downloads');
          break;
        case 3:
          print('go to Settings screen');
          break;
      }
    }

    void onSelectedAccount(BuildContext context, int item) {
      switch (item) {
        case 0:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UpdateProfilePage()),
          );
          break;
        case 1:
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChildRegistration()),
          );
          break;
        case 2:
          storage.remove('token');
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          break;
      }
    }

    FocusScopeNode currentFocus = FocusScope.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  color: Color.fromARGB(255, 196, 196, 196),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: IconButton(
                                icon: Icon(
                                  Icons.cottage_outlined,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LandingPage(),
                                      ));
                                }),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: TextFormField(
                            autocorrect: false,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 7),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                fillColor: Color.fromARGB(255, 103, 103, 103),
                                filled: true),
                            onFieldSubmitted: (term) {
                              String finalURL = _teController.text;
                              if (!finalURL.startsWith("https://")) {
                                finalURL = "https://" + finalURL;
                              }
                              if (_webViewController != null) {
                                updateLoading(true);
                                _webViewController
                                    .loadUrl(finalURL)
                                    .then((onValue) {})
                                    .catchError((e) {
                                  updateLoading(false);
                                });
                              }
                            },
                            controller: _teController,
                          ),
                        ),
                        PopupMenuButton<int>(
                          icon: Icon(
                            Icons.account_circle,
                            color: Colors.black,
                          ),
                          color: Color.fromARGB(255, 196, 196, 196),
                          onSelected: (item) =>
                              onSelectedAccount(context, item),
                          itemBuilder: (context) => [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(Icons.manage_accounts_rounded),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Manage Account',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.person_add),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Create Child Account',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.logout),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Log out',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            iconTheme: IconThemeData(color: Colors.black),
                          ),
                          child: PopupMenuButton<int>(
                            color: Color.fromARGB(255, 196, 196, 196),
                            onSelected: (item) =>
                                onSelectedMoreOptions(context, item),
                            itemBuilder: (context) => [
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
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(Icons.download),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Download',
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
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 9,
                  child: Stack(
                    children: <Widget>[
                      WebView(
                        initialUrl: widget.text.startsWith("https://")
                            ? widget.text
                            : "https://" + widget.text,
                        onPageFinished: (data) async {
                          updateLoading(false);
                          _webViewController.currentUrl().then((value) async {
                            _teController.text = (value.toString());
                            Map data = {
                              "url": value.toString(),
                              "title": value.toString()
                            };

                            String bodyNewUrl = json.encode(data);
                            final newUrl = await http.post(
                              Uri.parse(API_URL + "/urls"),
                              body: bodyNewUrl,
                              encoding: Encoding.getByName('utf-8'),
                            );
                            print("CREATE URL");
                            if (storage.read('parent_id') != null) {
                              print("CREATE URL PARENT");
                              Map dataVisit = {
                                "url_id": json.decode(newUrl.body)["id"],
                                "duration": 3,
                                "parent_id": storage.read('parent_id')
                              };
                              String bodyNewVisit = json.encode(dataVisit);
                              final newVisit = await http.post(
                                  Uri.parse(API_URL + "/parentvisits"),
                                  body: bodyNewVisit,
                                  encoding: Encoding.getByName('utf-8'),
                                  headers: {
                                    'Authorization':
                                        'Bearer ' + storage.read('token')
                                  });
                            } else {
                              print("CREATE URL cHILD");
                              Map dataVisit = {
                                "url_id": json.decode(newUrl.body)["id"],
                                "duration": 3,
                                "child_id": storage.read('child_id')
                              };
                              String bodyNewVisit = json.encode(dataVisit);
                              final newVisit = await http.post(
                                  Uri.parse(API_URL + "/childvisits"),
                                  body: bodyNewVisit,
                                  encoding: Encoding.getByName('utf-8'),
                                  headers: {
                                    'Authorization':
                                        'Bearer ' + storage.read('token')
                                  });
                              print(json.decode(newVisit.body));
                            }
                            print("enddddd");
                          });
                        },
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (webViewController) {
                          _webViewController = webViewController;
                        },
                      ),
                      (showLoading)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Center()
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
