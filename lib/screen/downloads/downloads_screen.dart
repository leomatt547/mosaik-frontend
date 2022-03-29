import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/downloads/download.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

import '../../constant.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  // List<Download> downloads = [
  //   Download(1, "Test.pdf", 1000, 1000, "www.google.com"),
  //   Download(2, "Test_Pake_Banget_WKWKWKWKWK.pdf", 1000, 1000,
  //       "www.tokobagustokopedia.com"),
  //   Download(3, "Test123_WKWKWKWKWK.pdf", 100000, 100000, "www.yahoo.com")
  // ];
  List<Download> downloads = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Downloads',
            style: GoogleFonts.average(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 196, 196, 196),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            String subtitle =
                "${downloads[index].receivedBytes} \u00B7 ${downloads[index].siteUrl}";

            return Card(
              child: ListTile(
                  title: Text(
                    downloads[index].targetPath,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.average(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.average(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    color: Colors.black,
                    onPressed: () {},
                  )),
            );
          },
          itemCount: downloads.length,
        ));
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


  Future<void> _getDownloadsData() async {
    String url;

    if (storage.read('parent_id') != null) {
      url = API_URL + '/parentdownloads?parent_id=${storage.read('parent_id')}';
    } else if (storage.read('child_id') != null) {
      url = API_URL + '/childdownloads?child_id=${storage.read('child_id')}';
    } else {
      _showFailedPopup();
      return;
    }
    try {
      final response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);

      if (data == null) {
        return;
      }

      downloads = data.map((el) {
        return Download(el['id'], el['target_path'], el['received_bytes'],
            el['total_bytes'], el['site_url']);
      })
          .toList()
          .reversed
          .toList();
    } catch (err) {
      _showFailedPopup();
    }
  }
}
