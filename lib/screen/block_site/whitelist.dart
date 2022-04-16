import 'package:flutter/material.dart';
import 'package:mosaic/models/history.dart';
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
    // ignore: avoid_print
    print("Whitelistwidget");
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

      // _whiteList = loadedProducts.reversed.toList();
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
    //     _whiteList.indexWhere((hist) => hist.id == id);
    // var existingProduct = _whiteList[existingProductIndex];
    // _whiteList.removeAt(existingProductIndex);
    // final response = await http.delete(url,
    //     headers: {'Authorization': 'Bearer ' + storage.read('token')});
    // if (response.statusCode >= 400) {
    //   _whiteList.insert(existingProductIndex, existingProduct);
    // }
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
