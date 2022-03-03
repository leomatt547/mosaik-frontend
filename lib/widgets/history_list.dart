import '../models/history.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List<History> history;
  final Function deleteHistory;

  HistoryList(this.history, this.deleteHistory);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          children: [
            Text(
              'History',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 450,
              child: history.isEmpty
                  ? Column(
                      children: <Widget>[
                        Text(
                          'No browsing history',
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Container(
                        //     height: 200,
                        //     child: Image.asset(
                        //       'assets/images/waiting.png',
                        //       fit: BoxFit.cover,
                        //     )),
                      ],
                    )
                  : ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 5,
                          ),
                          child: ListTile(
                            title: Text(
                              history[index].url.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(RegExp(
                                    r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)')
                                .firstMatch(history[index].url.toString())!
                                .group(1)
                                .toString()),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.black,
                              onPressed: () => deleteHistory(history[index].id),
                            ),
                          ),
                        );
                      },
                      itemCount: history.length,
                    ),
            )
          ],
        ));
  }
}
