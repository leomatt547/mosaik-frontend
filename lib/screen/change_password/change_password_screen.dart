import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:mosaic/utils/widgets.dart';
import 'package:mosaic/widgets/dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {}

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
            'Change Password',
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
                            Text('Old Password',
                                style: boldTextStyle(size: 14)),
                            8.height,
                            AppTextField(
                              decoration: inputDecoration(
                                hint: 'Enter your old password here',
                              ),
                              suffixIconColor: primaryColor,
                              textFieldType: TextFieldType.PASSWORD,
                              keyboardType: TextInputType.visiblePassword,
                              controller: oldPasswordController,
                              focus: oldPasswordFocusNode,
                              nextFocus: newPasswordFocusNode,
                            ),
                            16.height,
                            Text('New Password',
                                style: boldTextStyle(size: 14)),
                            8.height,
                            AppTextField(
                              decoration: inputDecoration(
                                hint: 'Enter your new password here',
                              ),
                              suffixIconColor: primaryColor,
                              textFieldType: TextFieldType.PASSWORD,
                              keyboardType: TextInputType.visiblePassword,
                              controller: newPasswordController,
                              focus: newPasswordFocusNode,
                              nextFocus: confirmPasswordFocusNode,
                            ),
                            16.height,
                            Text('Confirm New Password',
                                style: boldTextStyle(size: 14)),
                            8.height,
                            AppTextField(
                              decoration: inputDecoration(
                                hint: 'Re-type new password',
                              ),
                              suffixIconColor: primaryColor,
                              textFieldType: TextFieldType.PASSWORD,
                              keyboardType: TextInputType.visiblePassword,
                              controller: confirmNewPasswordController,
                              focus: confirmPasswordFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field is required';
                                }
                                if (value != newPasswordController.text) {
                                  return 'Password confirmation does not match';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      32.height,
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
                            String oldPw =
                                oldPasswordController.text.toString();
                            String newPw =
                                newPasswordController.text.toString();

                            Map data = {
                              'oldPassword': oldPw,
                              'newPassword': newPw,
                            };

                            String body = json.encode(data);
                            String url;
                            if (storage.read('parent_id') != null) {
                              url = API_URL +
                                  '/parents/password/${storage.read('parent_id')}';
                            } else if (storage.read('child_id') != null) {
                              url = API_URL +
                                  '/childs/password/${storage.read('child_id')}';
                            } else {
                              showErrorAlertDialog(
                                  context,
                                  'Failed',
                                  'Oops, something has gone wrong',
                                  () => finish(context));
                              return;
                            }

                            final response = await http.post(Uri.parse(url),
                                body: body,
                                encoding: Encoding.getByName('utf-8'),
                                headers: {
                                  'Authorization': 'Bearer ' + getToken()
                                });
                            Navigator.pop(context); //pop dialog
                            _changePassword(response);
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
                    child: Icon(Icons.key, color: primaryColor, size: 60),
                  ),
                ],
              ),
            ],
          ).paddingTop(60),
        ),
      ),
    );
  }

  void _changePassword(response) {
    if (response.statusCode == 200) {
      showSuccessfulAlertDialog(context, 'Success',
          'Your password has been successfully changed', () {
        finish(context);
        finish(context);
          });
    } else {
      showErrorAlertDialog(context, 'Failed', 'Oops, something has gone wrong',
          () => finish(context));
    }
  }
}
