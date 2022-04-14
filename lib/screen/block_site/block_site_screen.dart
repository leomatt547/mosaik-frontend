import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosaic/screen/add_block_site/add_block_site_screen.dart';
import 'package:mosaic/screen/block_site/blacklist.dart';
import 'package:mosaic/screen/block_site/whitelist.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class BlockSiteScreen extends StatefulWidget {
  const BlockSiteScreen({Key? key}) : super(key: key);

  @override
  _BlockSiteScreenState createState() => _BlockSiteScreenState();
}

class _BlockSiteScreenState extends State<BlockSiteScreen> {
  bool _isWhiteList = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'Block Sites',
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
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ).onTap(() {
                  AddBlockSiteScreen().launch(context);
                }),
              ],
              centerTitle: true,
              elevation: 0.0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: Container(
                height: context.height(),
                width: context.width(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/bg1.jpg'),
                        fit: BoxFit.cover)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Wrap(
                        spacing: 10, // set spacing here
                        children: <Widget>[
                          AppButton(
                            text: 'Whitelist',
                            color: _isWhiteList ? primaryColor : Colors.white,
                            textColor:
                                _isWhiteList ? Colors.white : primaryColor,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onTap: () {
                              setState(() {
                                _isWhiteList = true;
                              });
                            },
                          ),
                          AppButton(
                            text: 'Blacklist',
                            color: _isWhiteList ? Colors.white : primaryColor,
                            textColor:
                                _isWhiteList ? primaryColor : Colors.white,
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onTap: () {
                              setState(() {
                                _isWhiteList = false;
                              });
                            },
                          ),
                        ],
                      ).center(),
                    ),
                    16.height,
                    Expanded(
                        child: _isWhiteList
                            ? WhiteListWidget()
                            : BlackListWidget())
                  ],
                ))));
  }
}
