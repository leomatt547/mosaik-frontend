import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosaic/models/history.dart';
import 'package:mosaic/constant.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class HistoryScreen extends StatefulWidget {
  final Uri? url;
  final String? role;

  const HistoryScreen({Key? key, @required this.url, this.role})
      : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History> _userHistory = [];
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAndSetHistory(widget.url);
  }

  Future<void> fetchAndSetHistory(url) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(url);
      List<dynamic> extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      List<History> loadedProducts = [];
      loadedProducts = extractedData.map((dynamic hist) {
        String id = hist['id'].toString();
        String url = hist['Url']["url"];
        return History(id: id, url: url);
      }).toList();
      print(loadedProducts.length);

      setState(() {
        _isLoading = false;
      });

      _userHistory = loadedProducts.reversed.toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteHistory(String id) async {
    setState(() {
      _isLoading = true;
    });
    late Uri url;
    if (storage.read('parent_id') != null) {
      if (widget.role == 'child') {
        url = Uri.parse(API_URL + "/childvisits/" + id);
      } else {
        url = Uri.parse(API_URL + "/parentvisits/" + id);
      }
    }

    final existingProductIndex =
        _userHistory.indexWhere((hist) => hist.id == id);
    var existingProduct = _userHistory[existingProductIndex];
    _userHistory.removeAt(existingProductIndex);
    final response = await http.delete(url,
        headers: {'Authorization': 'Bearer ' + storage.read('token')});
    if (response.statusCode >= 400) {
      _userHistory.insert(existingProductIndex, existingProduct);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'History',
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
              systemOverlayStyle: SystemUiOverlayStyle.light,
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
                    : _userHistory.isEmpty
                        ? Text(
                            'No browsing history',
                            style: TextStyle(color: Colors.grey),
                          ).center()
                        : ListView.builder(
                            itemBuilder: (ctx, index) {
                              return Card(
                                elevation: 5,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 5,
                                ),
                                child: ListTile(
                                  title: Text(
                                    _userHistory[index].url.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Text(
                                      RegExp(r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)')
                                          .firstMatch(_userHistory[index]
                                              .url
                                              .toString())!
                                          .group(1)
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  trailing: storage.read('parent_id') != null
                                      ? IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: Colors.black,
                                          onPressed: () => deleteHistory(
                                              _userHistory[index].id!),
                                        )
                                      : null,
                                ),
                              );
                            },
                            itemCount: _userHistory.length,
                          ))));
  }
}
