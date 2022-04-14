import 'package:flutter/material.dart';
import 'package:mosaic/models/history.dart';
import 'package:mosaic/widgets/blocked_site_list.dart';

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
    // ignore: avoid_print
    print("Blacklistwidget");
    fetchAndSetHistory();
  }

  Future<void> fetchAndSetHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // final response = await http.get(url);
      // List<dynamic> extractedData = json.decode(response.body);
      // if (extractedData == null) {
      //   return;
      // }
      // List<History> loadedProducts = [];
      // loadedProducts = extractedData.map((dynamic hist) {
      //   String id = hist['id'].toString();
      //   String url = hist['Url']["url"];
      //   return History(id: id, url: url);
      // }).toList();
      setState(() {
        _isLoading = false;
      });

      // _blackList = loadedProducts.reversed.toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteBlockedSite(String id) async {
    setState(() {
      _isLoading = true;
    });
    // late Uri url;
    // if (storage.read('parent_id') != null) {
    //   if (widget.role == 'child') {
    //     url = Uri.parse(API_URL + "/childvisits/" + id);
    //   } else {
    //     url = Uri.parse(API_URL + "/parentvisits/" + id);
    //   }
    // }

    // final existingProductIndex =
    //     _blackList.indexWhere((hist) => hist.id == id);
    // var existingProduct = _blackList[existingProductIndex];
    // _blackList.removeAt(existingProductIndex);
    // final response = await http.delete(url,
    //     headers: {'Authorization': 'Bearer ' + storage.read('token')});
    // if (response.statusCode >= 400) {
    //   _blackList.insert(existingProductIndex, existingProduct);
    // }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                BlockedSiteList(
                    _blackList, deleteBlockedSite, "No Blacklisted Sites"),
              ],
            ),
    );
  }
}
