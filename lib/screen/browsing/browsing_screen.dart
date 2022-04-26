import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/block_site/block_site_screen.dart';
import 'package:mosaic/screen/children_history/children_list_history_screen.dart';
import 'package:mosaic/screen/downloads/downloads_screen.dart';
import 'package:mosaic/screen/history/history_screen.dart';
import 'package:mosaic/screen/landing/landing_screen.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:mosaic/utils/widgets.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mosaic/widgets/dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BrowsingScreen extends StatefulWidget {
  const BrowsingScreen(this.text);

  final String text;

  @override
  _BrowsingScreenState createState() => _BrowsingScreenState();
}

class _BrowsingScreenState extends State<BrowsingScreen> {
  late InAppWebViewController _webViewController;
  final TextEditingController _teController = TextEditingController();
  bool showLoading = false;

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  void updateLoading(bool ls) {
    setState(() {
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
          HistoryScreen(url: url).launch(context);
          break;
        case 2:
          const DownloadsScreen().launch(context);
          break;
        case 3:
          const ChildrenListHistoryScreen().launch(context);
          break;
        case 4:
          const BlockSiteScreen().launch(context);
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
                  color: Colors.white,
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
                                  LandingScreen().launch(context);
                                }),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: AppTextField(
                            enabled: false,
                            textFieldType: TextFieldType.URL,
                            decoration: inputDecoration(
                                hint: 'Type web address',
                                prefixIcon: Icons.lock),
                            onFieldSubmitted: (term) {
                              String finalURL = _teController.text;
                              if (!finalURL.startsWith("https://")) {
                                finalURL = "https://" + finalURL;
                              }
                              if (_webViewController != null) {
                                updateLoading(true);
                                _webViewController
                                    .loadUrl(
                                        urlRequest: URLRequest(
                                            url: Uri.parse(finalURL)))
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
                          data: Theme.of(context).copyWith(),
                          child: PopupMenuButton<int>(
                            color: Colors.white,
                            onSelected: (item) =>
                                onSelectedMoreOptions(context, item),
                            itemBuilder: (context) => [
                              PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.history,
                                      color: primaryColor,
                                    ),
                                    SizedBox(width: 8),
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
                                  children: const [
                                    Icon(Icons.download, color: primaryColor),
                                    SizedBox(width: 8),
                                    Text(
                                      'Download',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              if (storage.read('parent_id') != null)
                                const PopupMenuDivider(),
                              if (storage.read('parent_id') != null)
                                PopupMenuItem<int>(
                                  value: 3,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.history, color: primaryColor),
                                      SizedBox(width: 8),
                                      Text(
                                        'Children History',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              if (storage.read('parent_id') != null)
                                const PopupMenuDivider(),
                              if (storage.read('parent_id') != null)
                                PopupMenuItem<int>(
                                  value: 4,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.do_not_disturb_outlined,
                                          color: primaryColor),
                                      SizedBox(width: 8),
                                      Text(
                                        'Block Site',
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
                      (storage.read('parent_id') == null)
                          ? FutureBuilder(
                              future: validateSite(widget.text),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data == true) {
                                    return initWebview(widget.text);
                                  } else {
                                    return Container(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: 110,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                  color: primaryColor
                                                      .withOpacity(0.2),
                                                  shape: BoxShape.circle),
                                              child: const Icon(
                                                  Icons.do_not_disturb_outlined,
                                                  color: primaryColor,
                                                  size: 60),
                                            ),
                                            Text(
                                              "YOU'RE NOT ALLOWED TO ACCESS THIS SITE",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.average(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            DialogButton(
                                              child: const Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              radius: BorderRadius.circular(30),
                                              onPressed: () {
                                                LandingScreen().launch(context);
                                              },
                                              width: 120,
                                              color: primaryColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  );
                                }
                              })
                          : initWebview(widget.text),
                      (showLoading)
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
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

  Widget initWebview(site) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse(
              site.startsWith("https://") ? site : "https://" + site)),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(useOnDownloadStart: true),
      ),
      onLoadStop: (data, uri) async {
        updateLoading(false);
        _webViewController.getUrl().then((value) async {
          _teController.text = (value.toString());
          Map data = {"url": value.toString(), "title": value.toString()};

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
            await http.post(Uri.parse(API_URL + "/parentvisits"),
                body: bodyNewVisit,
                encoding: Encoding.getByName('utf-8'),
                headers: {'Authorization': 'Bearer ' + storage.read('token')});
          } else {
            Map dataVisit = {
              "url_id": json.decode(newUrl.body)["id"],
              "duration": 3,
              "child_id": storage.read('child_id')
            };
            String bodyNewVisit = json.encode(dataVisit);
            await http.post(Uri.parse(API_URL + "/childvisits"),
                body: bodyNewVisit,
                encoding: Encoding.getByName('utf-8'),
                headers: {'Authorization': 'Bearer ' + storage.read('token')});
          }
        });
      },
      onDownloadStart: (controller, url) async {
        String? path = await FilesystemPicker.open(
            title: 'Save to folder',
            fsType: FilesystemType.folder,
            context: context,
            rootDirectory: (await getApplicationDocumentsDirectory()).parent,
            pickText: 'Save file to this folder',
            folderIconColor: Colors.grey[200],
            requestPermission: () async =>
                await Permission.storage.request().isGranted);

        if (path! != null) {
          FlutterDownloader.enqueue(
            url: url.toString(),
            saveInPublicStorage: true,
            savedDir: path,
            showNotification: true,
            openFileFromNotification: true,
          );

          if (storage.read('parent_id') != null) {
            Map downloadData = {
              'target_path': path,
              'site_url': Uri.parse(url.toString()).host,
              'tab_url': url.toString(),
              'mime_type': p.extension(url.toString()),
              'parent_id': storage.read('parent_id'),
            };

            String bodyRequest = json.encode(downloadData);

            await http.post(Uri.parse(API_URL + '/parentdownloads'),
                body: bodyRequest,
                encoding: Encoding.getByName('utf-8'),
                headers: {'Authorization': 'Bearer ' + storage.read('token')});
          } else {
            Map downloadData = {
              'target_path': path,
              'site_url': Uri.parse(url.toString()).host,
              'tab_url': url.toString(),
              'mime_type': p.extension(url.toString()),
              'child_id': storage.read('child_id'),
            };

            String bodyRequest = json.encode(downloadData);

            await http.post(Uri.parse(API_URL + '/childdownloads'),
                body: bodyRequest,
                encoding: Encoding.getByName('utf-8'),
                headers: {'Authorization': 'Bearer ' + storage.read('token')});
          }
        }
      },
      // javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (webViewController) {
        _webViewController = webViewController;
      },
    );
  }

  Future<bool?> validateSite(site) async {
    print("child_id : ${storage.read('child_id')}");
    var urlSite = site.startsWith("https://") ? site : "https://" + site;
    try {
      // Validasi whitelist
      final resValWhite = await http.post(
          Uri.parse(API_URL + "/whitelist/check"),
          body: json.encode({'url': urlSite.toLowerCase()}),
          encoding: Encoding.getByName('utf-8'),
          headers: {'Authorization': 'Bearer ' + storage.read('token')});
      if (json.decode(resValWhite.body)["is_allowed"] == false) {
        final resValBlack = await http.post(
            Uri.parse(API_URL + "/blacklist/check"),
            body: json.encode({'url': urlSite.toLowerCase()}),
            encoding: Encoding.getByName('utf-8'),
            headers: {'Authorization': 'Bearer ' + storage.read('token')});
        print("dari Validate : ${json.decode(resValBlack.body)}");
        if (json.decode(resValBlack.body)["is_blocked"] == true) {
          return false;
        } else {
          final resValAI = await http.post(
            Uri.parse(API_URL + "/nsfw"),
            body: json.encode({
              'url': urlSite.toLowerCase(),
              "child_id": storage.read('child_id')
            }),
            encoding: Encoding.getByName('utf-8'),
          );
          if (json.decode(resValAI.body)["is_blocked"] == true) {
            return false;
          } else {
            return true;
          }
        }
      } else {
        return true;
      }
    } catch (e) {
      rethrow;
    }
  }
}
