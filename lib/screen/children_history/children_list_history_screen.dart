import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosaic/models/child.dart';
import 'package:mosaic/constant.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/screen/history/history_screen.dart';
import 'package:mosaic/utils/colors.dart';
import 'dart:convert';
import 'package:nb_utils/nb_utils.dart';

class ChildrenListHistoryScreen extends StatefulWidget {
  const ChildrenListHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ChildrenListHistoryScreen> createState() =>
      _ChildrenListHistoryScreenState();
}

class _ChildrenListHistoryScreenState extends State<ChildrenListHistoryScreen> {
  List<Child> _userChildren = [];
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

      _userChildren = loadedProducts.reversed.toList();
    } catch (error) {
      rethrow;
    }
  }

  void _navigateToHistoryChild(String id) {
    late Uri url;
    url = Uri.parse(API_URL + "/childvisits?child_id=" + id.toString());
    HistoryScreen(url: url, role: 'child').launch(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'Children',
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
                        image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover)),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : _userChildren.isEmpty
                        ? Text(
                            'You don\'t have any children yet',
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
                                child: InkWell(
                                  onTap: () {
                                    _navigateToHistoryChild(
                                        _userChildren[index].id!);
                                  },
                                  child: ListTile(
                                      leading: Icon(
                                        Icons.person,
                                        color: primaryColor,
                                        size: 56,
                                      ),
                                      title: Text(
                                        _userChildren[index].nama.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      subtitle: Text(
                                        _userChildren[index].email.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )),
                                ),
                              );
                            },
                            itemCount: _userChildren.length,
                          ))));
  }
}
