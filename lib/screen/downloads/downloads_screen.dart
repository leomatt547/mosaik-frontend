import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosaic/screen/downloads/download.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:mosaic/constant.dart';

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
  //   Download(2, "Test_Pake_Banget_WKWKWKWKWK.pdf", 1000, 1000,
  //       "www.tokobagustokopedia.com"),
  //   Download(2, "Test_Pake_Banget_WKWKWKWKWK.pdf", 1000, 1000,
  //       "www.tokobagustokopedia.com"),
  //   Download(2, "Test_Pake_Banget_WKWKWKWKWK.pdf", 1000, 1000,
  //       "www.tokobagustokopedia.com"),
  //   Download(2, "Test_Pake_Banget_WKWKWKWKWK.pdf", 1000, 1000,
  //       "www.tokobagustokopedia.com"),
  //   Download(2, "Test_Pake_Banget_WKWKWKWKWK.pdf", 1000, 1000,
  //       "www.tokobagustokopedia.com"),
  //   Download(2, "Test_Pake_Banget_WKWKWKWKWK.pdf", 1000, 1000,
  //       "www.tokobagustokopedia.com"),
  //   Download(2, "Test_Pake_Banget_WKWKWKWKWK.pdf", 1000, 1000,
  //       "www.tokobagustokopedia.com"),
  //   Download(3, "Test123_WKWKWKWKWK.pdf", 100000, 100000, "www.yahoo.com")
  // ];

  late List<Download> downloads;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDownloadsData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'Downloads',
                style: boldTextStyle(color: Colors.black, size: 20),
              ),
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ).onTap(() {
                finish(context);
              }),
              centerTitle: true,
              elevation: 0.0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: Container(
                height: context.height(),
                width: context.width(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bg1.jpg'),
                        fit: BoxFit.cover)),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : downloads.isEmpty
                        ? Text(
                            'No downloads yet',
                            style: TextStyle(color: Colors.grey),
                          ).center()
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              String subtitle =
                                  "${downloads[index].receivedBytes} \u00B7 ${downloads[index].siteUrl}";

                              return Card(
                                child: ListTile(
                                    leading: Icon(
                                      Icons.download_done,
                                      color: primaryColor,
                                      size: 56,
                                    ),
                                    title: Text(
                                      downloads[index].targetPath,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Text(
                                      subtitle,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.black,
                                      onPressed: () {
                                        _deleteDownload(downloads[index])
                                            .whenComplete(() {
                                          return;
                                        });
                                      },
                                    )),
                              );
                            },
                            itemCount: downloads.length,
                          ))));
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
            onPressed: () {
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            })
      ],
    ).show();
  }

  Future<void> _deleteDownload(Download item) async {
    String url;

    setState(() {
      _isLoading = true;
    });

    if (storage.read('parent_id') != null) {
      url = API_URL + '/parentdownloads/${item.id}';
    } else if (storage.read('child_id') != null) {
      url = API_URL + '/childdownloads/${item.id}';
    } else {
      _showFailedPopup();
      return;
    }

    try {
      final response = await http.delete(Uri.parse(url),
          headers: {'Authorization': 'Bearer ' + getToken()});

      print(response.statusCode);
      if (response.statusCode != 204) {
        _showFailedPopup();
      }

      await _getDownloadsData();

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      _showFailedPopup();
    }
  }

  Future<void> _getDownloadsData() async {
    setState(() {
      _isLoading = true;
    });
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

      downloads = data
          .map<Download>((el) {
            print(el['id']);
            return Download(el['id'], el['target_path'], el['received_bytes'],
                el['total_bytes'], el['site_url']);
          })
          .toList()
          .reversed
          .toList();

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      _showFailedPopup();
    }
  }
}
