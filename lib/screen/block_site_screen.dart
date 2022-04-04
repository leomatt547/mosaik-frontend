import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/models/history.dart';
import 'package:mosaic/screen/add_block_site_screen.dart';
import 'package:mosaic/widgets/blocked_site_list.dart';

class BlockSiteScreen extends StatefulWidget {
  const BlockSiteScreen({Key? key}) : super(key: key);

  @override
  _BlockSiteScreenState createState() => _BlockSiteScreenState();
}

class _BlockSiteScreenState extends State<BlockSiteScreen> {
  List<History> _blockedSite = [];
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

      // _blockedSite = loadedProducts.reversed.toList();
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
    //     _blockedSite.indexWhere((hist) => hist.id == id);
    // var existingProduct = _blockedSite[existingProductIndex];
    // _blockedSite.removeAt(existingProductIndex);
    // final response = await http.delete(url,
    //     headers: {'Authorization': 'Bearer ' + storage.read('token')});
    // if (response.statusCode >= 400) {
    //   _blockedSite.insert(existingProductIndex, existingProduct);
    // }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Block site',
          style: GoogleFonts.average(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AddBlockSiteScreen()),
              );
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 196, 196, 196),
      ),
      body: SingleChildScrollView(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  BlockedSiteList(_blockedSite, deleteBlockedSite),
                ],
              ),
      ),
    );
  }
}
