import 'package:flutter/material.dart';
import 'package:mosaic/models/child.dart';
import 'package:mosaic/screen/history_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mosaic/widgets/child_list.dart';

class ChildListHistoryScreen extends StatefulWidget {
  const ChildListHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ChildListHistoryScreen> createState() => _ChildListHistoryScreenState();
}

class _ChildListHistoryScreenState extends State<ChildListHistoryScreen> {
  List<Child> _userChild = [];
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchAndSetChild();
  }

  Future<void> fetchAndSetChild() async {
    setState(() {
      _isLoading = true;
    });
    late Uri url = Uri.parse(
        API_URL + "/childs?parent_id=" + storage.read('parent_id').toString());

    try {
      final response = await http.get(url);
      List<dynamic> extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      List<Child> loadedProducts = [];
      loadedProducts = extractedData.map((dynamic child) {
        String id = child['id'].toString();
        String nama = child['nama'].toString();
        String email = child['email'].toString();
        return Child(id: id, nama: nama, email: email);
      }).toList();
      setState(() {
        _isLoading = false;
      });

      _userChild = loadedProducts.reversed.toList();
    } catch (error) {
      rethrow;
    }
  }

  void _navigateToHistoryChild(String id) {
    late Uri url;
    url = Uri.parse(API_URL + "/childvisits?child_id=" + id.toString());
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryScreen(url: url, role: 'child'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Child list',
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
                  ChildList(_userChild, _navigateToHistoryChild),
                ],
              ),
      ),
    );
  }
}
