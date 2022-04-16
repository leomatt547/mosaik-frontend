import 'package:flutter/material.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:mosaic/utils/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class AddBlockSiteScreen extends StatefulWidget {
  const AddBlockSiteScreen({Key? key}) : super(key: key);

  @override
  _AddBlockSiteScreenState createState() => _AddBlockSiteScreenState();
}

class _AddBlockSiteScreenState extends State<AddBlockSiteScreen> {
  final _formKey = GlobalKey<FormState>();
  String _blockType = 'whitelist';

  TextEditingController urlController = TextEditingController();
  FocusNode urlFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Add New Site',
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
          centerTitle: true,
          elevation: 0.0,
          brightness: Brightness.dark,
        ),
        body: Container(
          height: context.height(),
          width: context.width(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover)),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 80),
                padding:
                EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
                width: context.width(),
                height: context.height(),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 0.5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('URL', style: boldTextStyle()),
                                8.height,
                                AppTextField(
                                  decoration: inputDecoration(
                                    hint: 'Enter URL here',
                                    prefixIcon: Icons.person_outline_outlined,
                                  ),
                                  textFieldType: TextFieldType.URL,
                                  keyboardType: TextInputType.url,
                                  controller: urlController,
                                  focus: urlFocusNode,
                                ),
                                16.height,
                                Text('Add to', style: boldTextStyle()),
                                8.height,
                                DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: inputDecoration(hint: "Select here"),
                                  items: <String>['Whitelist', 'Blacklist'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    _blockType = value.toString().toLowerCase();
                                  },
                                ),
                              ],
                            ),
                          ),
                          32.height,
                          AppButton(
                            color: primaryColor,
                            width: context.width() * 0.8,
                            child: Text('ADD',
                                style: boldTextStyle(color: Colors.white)),
                            shapeBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                // _showLoading();

                                Map data = {
                                  'url': urlController.text.toString(),
                                  'type': _blockType,
                                };
                                // ignore: avoid_print
                                print(data);

                                // String body = json.encode(data);
                                // String url;
                                // if (storage.read('parent_id') != null) {
                                //   url = API_URL +
                                //       '/parents/${storage.read('parent_id')}';
                                // } else if (storage.read('child_id') != null) {
                                //   url = API_URL +
                                //       '/childs/${storage.read('child_id')}';
                                // } else {
                                //   _showFailedPopup();
                                //   return;
                                // }

                                // final response = await http.put(
                                //     Uri.parse(url),
                                //     body: body,
                                //     encoding: Encoding.getByName('utf-8'),
                                //     headers: {
                                //       'Authorization': 'Bearer ' + getToken()
                                //     });

                                // Navigator.pop(context); //pop dialog
                              }
                            },
                          ).center()
                        ],
                      ),
                    )),
              ),
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: Icon(Icons.do_not_disturb_outlined, color: primaryColor, size: 60),
                  ),
                ],
              ),
            ],
          ).paddingTop(60),
        ),
      ),
    );
  }
}
