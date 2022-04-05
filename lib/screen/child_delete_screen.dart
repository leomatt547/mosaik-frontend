import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/models/childs.dart';

import 'package:mosaic/widgets/appbar.dart';
import 'package:mosaic/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rflutter_alert/rflutter_alert.dart';

import '../widgets/button.dart';

class ChildDeleteScreen extends StatefulWidget {
  const ChildDeleteScreen({Key? key}) : super(key: key);

  @override
  State<ChildDeleteScreen> createState() => _ChildDeleteScreenState();
}

class _ChildDeleteScreenState extends State<ChildDeleteScreen> {
  List<Child> _childs = [];
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
    late Uri url;

    url = Uri.parse(
        API_URL + "/childs?parent_id=" + storage.read('parent_id').toString());

    try {
      final response = await http.get(url);
      List<dynamic> extractedData = json.decode(response.body);
      // ignore: unnecessary_null_comparison
      if (extractedData == null) {
        return;
      }
      List<Child> loadedProducts = [];
      loadedProducts = extractedData.map((dynamic childResponse) {
        String id = childResponse['id'].toString();
        String nama = childResponse['nama'];
        String email = childResponse['email'];
        return Child(id: id, nama: nama, email: email);
      }).toList();
      setState(() {
        _isLoading = false;
        _childs = loadedProducts.reversed.toList();
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteChild(String? id) async {
    setState(() {
      _isLoading = true;
    });
    late Uri url;
    url = Uri.parse(API_URL + "/childs/" + id!);

    final existingProductIndex = _childs.indexWhere((hist) => hist.id == id);
    var existingProduct = _childs[existingProductIndex];
    _childs.removeAt(existingProductIndex);
    final response = await http.delete(url,
        headers: {'Authorization': 'Bearer ' + storage.read('token')});
    if (response.statusCode >= 400) {
      _childs.insert(existingProductIndex, existingProduct);
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
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Column(
                        children: [
                          Text(
                            'Children',
                            style: GoogleFonts.average(
                              fontSize: 28,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 450,
                            child: _childs.isEmpty
                                ? Column(
                                    children: <Widget>[
                                      Text(
                                        'You haven\'t registered your children',
                                        style: GoogleFonts.average(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
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
                                            _childs[index].nama.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.average(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          subtitle: Text(
                                            _childs[index].email.toString(),
                                            style: GoogleFonts.average(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: storage.read('parent_id') !=
                                                  null
                                              ? IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  color: Colors.black,
                                                  onPressed: () => {
                                                    Alert(
                                                      context: context,
                                                      type: AlertType.warning,
                                                      title: 'Delete Account',
                                                      desc:
                                                          'Are you sure want to delete this account?',
                                                      style: AlertStyle(
                                                          titleStyle:
                                                              GoogleFonts
                                                                  .average(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          descStyle: GoogleFonts
                                                              .average(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          )),
                                                      buttons: [
                                                        DialogButton(
                                                            color: Colors.red,
                                                            child: Text(
                                                                "Delete",
                                                                style:
                                                                    GoogleFonts
                                                                        .average(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            onPressed: () => {
                                                                  deleteChild(_childs[
                                                                          index]
                                                                      .id
                                                                      .toString()),
                                                                  Navigator.pop(
                                                                      context),
                                                                }),
                                                        cancelButton(context),
                                                      ],
                                                    ).show()
                                                  },
                                                )
                                              : null,
                                        ),
                                      );
                                    },
                                    itemCount: _childs.length,
                                  ),
                          )
                        ],
                      ))
                ],
              ),
      ),
    );
  }
}
