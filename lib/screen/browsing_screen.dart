import 'package:flutter/material.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                          child: TextField(
                            autocorrect: false,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.black,
                                      width: 2),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.black,
                                      width: 2),
                                )),
                            controller: _teController,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                                onPressed: () {
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
                                }),
                          ),
                        )
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
                        initialUrl: 'https://' + widget.text,
                        onPageFinished: (data) {
                          updateLoading(false);
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
