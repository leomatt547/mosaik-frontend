import 'package:flutter/material.dart';
import 'package:mosaic/models/history.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:mosaic/widgets/history_list.dart';
import 'package:mosaic/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<History> _userHistory = [
    // History(
    //   id: 'url1',
    //   url:
    //       'https://www.youtube.com/watch?v=Zi9To04PO78&list=RDuyaKoj7wABY&index=4&ab_channel=TheScriptVEVO',
    // ),
    // History(
    //   id: 'url2',
    //   url: 'https://translate.google.co.id/?sl=en&tl=id&op=translate&hl=id',
    // ),
    // History(
    //   id: 'url3',
    //   url: 'https://id-id.facebook.com/',
    // ),
    // History(
    //   id: 'url4',
    //   url: 'https://akademik.itb.ac.id/?context=mahasiswa:13519112',
    // ),
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
        return new History(id: id, url: url);
      }).toList();
      setState(() {
        _isLoading = false;
      });
      _userHistory = loadedProducts.reversed.toList();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteHistory(String id) async {
    setState(() {
      _isLoading = true;
    });
    late Uri url;
    if (storage.read('parent_id') != null) {
      url = Uri.parse(API_URL + "/parentvisits/" + id);
    } else {
      url = Uri.parse(API_URL + "/childvisits/" + id);
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
    // existingProduct = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  HistoryList(_userHistory, deleteHistory),
                ],
              ),
      ),
    );
  }
}
