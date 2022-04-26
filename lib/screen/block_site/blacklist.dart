import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mosaic/models/history.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import 'package:mosaic/screen/block_site/blocked_site_list.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class BlackListWidget extends StatefulWidget {
  const BlackListWidget({Key? key}) : super(key: key);

  @override
  State<BlackListWidget> createState() => _BlackListWidgetState();
}

class _BlackListWidgetState extends State<BlackListWidget> {
  List<History> _blackList = [];
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
      String url = API_URL +
          '/blacklist?parent_id=${storage.read('parent_id').toString()}';
      final response = await http.get(Uri.parse(url));
      List<dynamic> extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      List<History> loadedProducts = [];
      loadedProducts = extractedData.map((dynamic hist) {
        String id = hist['id'].toString();
        String url = hist["url"];
        return History(id: id, url: url);
      }).toList();
      setState(() {
        _isLoading = false;
      });

      _blackList = loadedProducts.reversed.toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteBlockedSite(String id) async {
    setState(() {
      _isLoading = true;
    });
    late Uri url = Uri.parse(API_URL + "/blacklist/" + id);

    final existingProductIndex = _blackList.indexWhere((site) => site.id == id);
    var existingProduct = _blackList[existingProductIndex];
    _blackList.removeAt(existingProductIndex);
    final response = await http.delete(url,
        headers: {'Authorization': 'Bearer ' + storage.read('token')});
    if (response.statusCode >= 400) {
      _blackList.insert(existingProductIndex, existingProduct);
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
            _blackList, deleteBlockedSite, "No Blacklisted Sites");
  }
}
