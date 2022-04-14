import 'package:mosaic/constant.dart';
import 'package:mosaic/models/history.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';

class BlockedSiteList extends StatelessWidget {
  final List<History> blockedSite;
  final Function deleteBlockedSite;
  final String messageInfo;

  // ignore: use_key_in_widget_constructors
  const BlockedSiteList(
      this.blockedSite, this.deleteBlockedSite, this.messageInfo);

  @override
  Widget build(BuildContext context) {
    return blockedSite.isEmpty
        ? Text(
            messageInfo,
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
                child: ListTile(
                  title: Text(
                    blockedSite[index].url.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    RegExp(r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)')
                        .firstMatch(blockedSite[index].url.toString())!
                        .group(1)
                        .toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: storage.read('parent_id') != null
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.black,
                          onPressed: () =>
                              deleteBlockedSite(blockedSite[index].id),
                        )
                      : null,
                ),
              );
            },
            itemCount: blockedSite.length,
          );
  }
}
