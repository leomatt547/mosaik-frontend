import '../models/history.dart';
import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';

class BlockedSiteList extends StatelessWidget {
  final List<History> blockedSite;
  final Function deleteBlockedSite;
  final String messageInfo;

  // ignore: use_key_in_widget_constructors
  const BlockedSiteList(
      this.blockedSite, this.deleteBlockedSite, this.messageInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 450,
              child: blockedSite.isEmpty
                  ? Column(
                      children: <Widget>[
                        Text(
                          messageInfo,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
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
                              blockedSite[index].url.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(RegExp(
                                    r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)')
                                .firstMatch(blockedSite[index].url.toString())!
                                .group(1)
                                .toString()),
                            trailing: storage.read('parent_id') != null
                                ? IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.black,
                                    onPressed: () => deleteBlockedSite(
                                        blockedSite[index].id),
                                  )
                                : null,
                          ),
                        );
                      },
                      itemCount: blockedSite.length,
                    ),
            )
          ],
        ));
  }
}
