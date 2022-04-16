import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mosaic/models/history.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import 'package:mosaic/screen/block_site/blocked_site_list.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class WhiteListWidget extends StatefulWidget {
  const WhiteListWidget({Key? key}) : super(key: key);

  @override
  State<WhiteListWidget> createState() => _WhiteListWidgetState();
}

class _WhiteListWidgetState extends State<WhiteListWidget> {
  List<History> _whiteList = [
    History(id: '1', url: 'google.com/1223/4444'),
    History(id: '1', url: 'google.com/1223/4444'),
    History(id: '1', url: 'google.com/1223/4444'),
    History(id: '1', url: 'google.com/1223/4444'),
  ];
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAndSetHistory();
  }

  Future<void> fetchAndSetHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String url = API_URL + '/whitelist';
      final response = await http.get(Uri.parse(url));
      List<dynamic> extractedData = json.decode(response.body);

      List<History> loadedProducts = [];
      loadedProducts = extractedData.map((dynamic site) {
        String id = site['id'].toString();
        String url = site["url"];
        return History(id: id, url: url);
      }).toList();
      print(loadedProducts);
      setState(() {
        _isLoading = false;
      });

      _whiteList = loadedProducts.reversed.toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteBlockedSite(String id) async {
    setState(() {
      _isLoading = true;
    });
    late Uri url = Uri.parse(API_URL + "/whitelist/" + id);
    final existingProductIndex = _whiteList.indexWhere((site) => site.id == id);
    var existingProduct = _whiteList[existingProductIndex];
    _whiteList.removeAt(existingProductIndex);
    final response = await http.delete(url,
        headers: {'Authorization': 'Bearer ' + storage.read('token')});
    if (response.statusCode >= 400) {
      _whiteList.insert(existingProductIndex, existingProduct);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : BlockedSiteList(
            _whiteList, deleteBlockedSite, "No Whitelisted Sites");
  }
}
