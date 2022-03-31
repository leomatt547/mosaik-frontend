import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/history_screen.dart';
import 'package:mosaic/screen/landing_screen.dart';
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
  TextEditingController _teController = TextEditingController();
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
          // ignore: avoid_print
          print('New tab');
          break;
        case 1:
          late Uri url;

          if (storage.read('parent_id') != null) {
            url = Uri.parse(API_URL +
                "/parentvisits?parent_id=" +
                storage.read('parent_id').toString());
          } else {
            url = Uri.parse(API_URL +
                "/childvisits?child_id=" +
                storage.read('child_id').toString());
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryScreen(
                  url: url,
                ),
              ));
          break;
        case 2:
          // ignore: avoid_print
          print('Downloads');
          break;
        case 3:
          // ignore: avoid_print
          print('go to Settings screen');
          break;
      }
    }

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
                  color: const Color.fromARGB(255, 196, 196, 196),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: IconButton(
                                icon: const Icon(
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
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            decoration: const InputDecoration(
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
                        const CustomAppBar()
                            .handleUserTypeAccountButton(context),
                        Theme(
                          data: Theme.of(context).copyWith(
                            iconTheme: const IconThemeData(color: Colors.black),
                          ),
                          child: PopupMenuButton<int>(
                            color: const Color.fromARGB(255, 196, 196, 196),
                            onSelected: (item) =>
                                onSelectedMoreOptions(context, item),
                            itemBuilder: (context) => [
                              PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  children: const [
                                    Icon(Icons.history),
                                    SizedBox(width: 8),
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
                                  children: const [
                                    Icon(Icons.download),
                                    SizedBox(width: 8),
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
                                  children: const [
                                    Icon(Icons.settings),
                                    SizedBox(width: 8),
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
                            if (storage.read('parent_id') != null) {
                              Map dataVisit = {
                                "url_id": json.decode(newUrl.body)["id"],
                                "duration": 3,
                                "parent_id": storage.read('parent_id')
                              };
                              String bodyNewVisit = json.encode(dataVisit);
                              await http.post(
                                  Uri.parse(API_URL + "/parentvisits"),
                                  body: bodyNewVisit,
                                  encoding: Encoding.getByName('utf-8'),
                                  headers: {
                                    'Authorization':
                                        'Bearer ' + storage.read('token')
                                  });
                            } else {
                              Map dataVisit = {
                                "url_id": json.decode(newUrl.body)["id"],
                                "duration": 3,
                                "child_id": storage.read('child_id')
                              };
                              String bodyNewVisit = json.encode(dataVisit);
                              await http.post(
                                  Uri.parse(API_URL + "/childvisits"),
                                  body: bodyNewVisit,
                                  encoding: Encoding.getByName('utf-8'),
                                  headers: {
                                    'Authorization':
                                        'Bearer ' + storage.read('token')
                                  });
                            }
                          });
                        },
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (webViewController) {
                          _webViewController = webViewController;
                        },
                      ),
                      (showLoading)
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Center()
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
