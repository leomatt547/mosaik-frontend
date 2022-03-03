import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/screen/history_screen.dart';
import 'package:mosaic/screen/landing_screen.dart';
import 'package:mosaic/screen/update_profile.dart';
import 'package:flutter/gestures.dart';
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
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                    flex: 9,
                    child: Stack(
                      children: <Widget>[
                        WebView(
                          initialUrl: 'https://' + widget.text,
                          onPageFinished: (data) {
                            print(_webViewController.currentUrl());
                            updateLoading(false);
                            _webViewController.currentUrl().then((value) =>
                                _teController.text = (value.toString()));
                          },
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (webViewController) {
                            _webViewController = webViewController;
                          },
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTapDown: (_) => currentFocus.unfocus(),
                          child: Container(),
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
      ),
    );
  }
}
