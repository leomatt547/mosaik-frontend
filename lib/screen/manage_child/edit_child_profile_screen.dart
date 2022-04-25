import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/screen/change_password/change_password_screen.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:mosaic/utils/widgets.dart';
import 'package:mosaic/widgets/dialog.dart';
import 'package:nb_utils/nb_utils.dart';

class EditChildProfileScreen extends StatefulWidget {
  final String id;

  const EditChildProfileScreen({required this.id, Key? key}) : super(key: key);

  @override
  _EditChildProfileScreenState createState() => _EditChildProfileScreenState();
}

class _EditChildProfileScreenState extends State<EditChildProfileScreen> with WidgetsBindingObserver{
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    init();
  }

  Future<void> init() async {
    _getUserData(widget.id);
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
            'Edit Child Profile',
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
                      Text('Personal Information',
                          style: boldTextStyle(size: 18)),
                      16.height,
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
                            Text('Full Name', style: boldTextStyle(size: 14)),
                            8.height,
                            AppTextField(
                              decoration: inputDecoration(
                                hint: 'Enter full name here',
                                prefixIcon: Icons.person_outline_outlined,
                              ),
                              textFieldType: TextFieldType.NAME,
                              keyboardType: TextInputType.name,
                              controller: nameController,
                              focus: nameFocusNode,
                              nextFocus: emailFocusNode,
                            ),
                            16.height,
                            Text('Email', style: boldTextStyle(size: 14)),
                            8.height,
                            AppTextField(
                              decoration: inputDecoration(
                                  hint: 'Enter email here',
                                  prefixIcon: Icons.email_outlined),
                              textFieldType: TextFieldType.EMAIL,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              focus: emailFocusNode,
                            ),
                          ],
                        ),
                      ),
                      32.height,
                      AppButton(
                        color: Colors.redAccent,
                        width: context.width() * 0.8,
                        child: Text('DELETE ACCOUNT',
                            style: boldTextStyle(color: Colors.white)),
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onTap: () {
                          showConfirmDialogCustom(context,
                              title: 'Delete Account',
                              subTitle:
                                  'Are you sure want to delete this account?',
                              dialogType: DialogType.DELETE,
                              onAccept: (buildContext) async {
                            showLoading(buildContext, 'Processing...');
                            await deleteChild(widget.id);
                          });
                        },
                      ).center(),
                      16.height,
                      AppButton(
                        color: primaryColor,
                        width: context.width() * 0.8,
                        child: Text('SAVE',
                            style: boldTextStyle(color: Colors.white)),
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            showLoading(context, 'Processing...');

                            Map data = {
                              'nama': nameController.text.toString(),
                              'email': emailController.text.toString(),
                            };

                            String body = json.encode(data);
                            String url = API_URL + '/childs/${widget.id}';

                            final response = await http.put(Uri.parse(url),
                                body: body,
                                encoding: Encoding.getByName('utf-8'),
                                headers: {
                                  'Authorization': 'Bearer ' + getToken()
                                });

                            Navigator.pop(context); //pop dialog
                            _updateProfile(response);
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
                    child: Icon(Icons.person, color: primaryColor, size: 60),
                  ),
                ],
              ),
            ],
          ).paddingTop(60),
        ),
      ),
    );
  }

  void _updateProfile(response) {
    if (response.statusCode == 200) {
      showSuccessfulAlertDialog(context, 'Success',
          'Your profile has been successfully changed', () => finish(context));
    } else {
      showErrorAlertDialog(context, 'Failed', 'Oops, something has gone wrong',
          () => finish(context));
    }
  }

  Future<void> _getUserData(String id) async {
    print(id);
    String url = API_URL + '/childs/$id';

    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body);

    if (extractedData == null) {
      return;
    }

    if (extractedData['nama'] != null && extractedData['email'] != null) {
      nameController.text = extractedData['nama'];
      emailController.text = extractedData['email'];
    }
  }

  Future<void> deleteChild(String? id) async {
    late Uri url;
    url = Uri.parse(API_URL + "/childs/" + id!);

    final response = await http.delete(url,
        headers: {'Authorization': 'Bearer ' + storage.read('token')});

    Navigator.pop(context);

    if (response.statusCode >= 400) {
      showErrorAlertDialog(context, 'Failed', 'Oops, something has gone wrong',
          () => finish(context));
    } else {
      showSuccessfulAlertDialog(
          context, 'Success', 'Account has been successfully deleted', () {
        finish(context);
        finish(context, true);
      });
    }
  }
}
