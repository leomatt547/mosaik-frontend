import 'package:flutter/material.dart';
import 'package:mosaic/models/history.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/widgets/history_list.dart';
import 'package:mosaic/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'History list',
          style: GoogleFonts.average(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
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
