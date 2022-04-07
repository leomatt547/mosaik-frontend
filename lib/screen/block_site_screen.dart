import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mosaic/screen/add_block_site_screen.dart';
import 'package:mosaic/widgets/blacklist.dart';
import 'package:mosaic/widgets/whitelist.dart';

class BlockSiteScreen extends StatefulWidget {
  const BlockSiteScreen({Key? key}) : super(key: key);

  @override
  _BlockSiteScreenState createState() => _BlockSiteScreenState();
}

class _BlockSiteScreenState extends State<BlockSiteScreen> {
  var _isWhiteList = false;
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Wrap(
              spacing: 10, // set spacing here
              children: <Widget>[
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 196, 196, 196),
                        ),
                        child: Text(
                          "Whitelist",
                          style: GoogleFonts.average(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isWhiteList = true;
                          });
                        })),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 196, 196, 196),
                        ),
                        child: Text(
                          "Blacklist",
                          style: GoogleFonts.average(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isWhiteList = false;
                          });
                        })),
              ],
            ),
          ),
          _isWhiteList ? const WhiteListWidget() : const BlackListWidget(),
        ],
      ),
    );
  }
}
