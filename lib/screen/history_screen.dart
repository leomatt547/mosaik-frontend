import 'package:flutter/material.dart';
import 'package:mosaic/models/history.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:mosaic/widgets/history_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<History> _userHistory = [
    History(
      id: 'url1',
      url:
          'https://www.youtube.com/watch?v=Zi9To04PO78&list=RDuyaKoj7wABY&index=4&ab_channel=TheScriptVEVO',
    ),
    History(
      id: 'url2',
      url: 'https://translate.google.co.id/?sl=en&tl=id&op=translate&hl=id',
    ),
    History(
      id: 'url3',
      url: 'https://id-id.facebook.com/',
    ),
    History(
      id: 'url4',
      url: 'https://akademik.itb.ac.id/?context=mahasiswa:13519112',
    ),
  ];
  void _deleteHistory(String id) {
    setState(() {
      _userHistory.removeWhere((hstr) => hstr.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            HistoryList(_userHistory, _deleteHistory),
          ],
        ),
      ),
    );
  }
}
