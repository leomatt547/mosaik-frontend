import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/screen/downloads/download.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  List<Download> downloads = [
    Download(1, "Test.pdf", 1000, 1000, "www.google.com"),
    Download(2, "Test_Pake_Banget_WKWKWKWKWK.pdf", 1000, 1000,
        "www.tokobagustokopedia.com"),
    Download(3, "Test123_WKWKWKWKWK.pdf", 100000, 100000, "www.yahoo.com")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Downloads',
            style: GoogleFonts.average(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 196, 196, 196),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            String subtitle =
                "${downloads[index].receivedBytes} \u00B7 ${downloads[index].siteUrl}";

            return Card(
              child: ListTile(
                  title: Text(
                    downloads[index].targetPath,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.average(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.average(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    color: Colors.black,
                    onPressed: () {},
                  )),
            );
          },
          itemCount: downloads.length,
        ));
  }
}
