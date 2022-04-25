import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/login/login_screen.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:mosaic/widgets/dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/utils/widgets.dart';

class RegisterChildScreen extends StatefulWidget {
  static String tag = '/registerScreen';

  const RegisterChildScreen({Key? key}) : super(key: key);

  @override
  _RegisterChildScreenState createState() => _RegisterChildScreenState();
}

class _RegisterChildScreenState extends State<RegisterChildScreen> {
  final _formKey = GlobalKey<FormState>();

  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  FocusNode confirmPassWordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
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
          'Create Child Account',
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
          width: context.width(),
          height: context.height(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  50.height,
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: context.width(),
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          margin: EdgeInsets.only(top: 55.0),
                          decoration: boxDecorationWithShadow(
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    50.height,
                                    Text("Full Name",
                                        style: boldTextStyle(size: 14)),
                                    8.height,
                                    AppTextField(
                                      decoration: inputDecoration(
                                        hint: 'Enter child\'s full name here',
                                        prefixIcon:
                                            Icons.person_outline_outlined,
                                      ),
                                      textFieldType: TextFieldType.NAME,
                                      keyboardType: TextInputType.name,
                                      controller: fullNameController,
                                      focus: fullNameFocusNode,
                                      nextFocus: emailFocusNode,
                                    ),
                                    16.height,
                                    Text("Email",
                                        style: boldTextStyle(size: 14)),
                                    8.height,
                                    AppTextField(
                                      decoration: inputDecoration(
                                          hint: 'Enter child\'s email here',
                                          prefixIcon: Icons.email_outlined),
                                      textFieldType: TextFieldType.EMAIL,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      focus: emailFocusNode,
                                      nextFocus: passWordFocusNode,
                                    ),
                                    16.height,
                                    Text("Password",
                                        style: boldTextStyle(size: 14)),
                                    8.height,
                                    AppTextField(
                                      decoration: inputDecoration(
                                          hint: 'Enter child\'s password here',
                                          prefixIcon: Icons.lock_outline),
                                      suffixIconColor: primaryColor,
                                      textFieldType: TextFieldType.PASSWORD,
                                      isPassword: true,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: passwordController,
                                      focus: passWordFocusNode,
                                      nextFocus: confirmPassWordFocusNode,
                                    ),
                                    16.height,
                                    Text("Confirm Password",
                                        style: boldTextStyle(size: 14)),
                                    8.height,
                                    AppTextField(
                                      decoration: inputDecoration(
                                          hint: 'Re-type password',
                                          prefixIcon: Icons.lock_outline),
                                      suffixIconColor: primaryColor,
                                      textFieldType: TextFieldType.PASSWORD,
                                      isPassword: true,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: confirmPasswordController,
                                      focus: confirmPassWordFocusNode,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'This field is required';
                                        }
                                        if (value != passwordController.text) {
                                          return 'Password confirmation does not match';
                                        }
                                      },
                                    ),
                                    30.height,
                                    AppButton(
                                            text: "CREATE",
                                            color: primaryColor,
                                            textColor: Colors.white,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            width: context.width(),
                                            onTap: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                showLoading(
                                                    context, 'Processing...');

                                                Map data = {
                                                  'nama': fullNameController
                                                      .text
                                                      .toString(),
                                                  'email': emailController.text
                                                      .toString(),
                                                  'password': passwordController
                                                      .text
                                                      .toString(),
                                                  'parent_id':
                                                      storage.read('parent_id'),
                                                };

                                                String body = json.encode(data);

                                                final response = await http
                                                    .post(
                                                        Uri.parse(API_URL +
                                                            "/childs"),
                                                        body: body,
                                                        encoding:
                                                            Encoding.getByName(
                                                                'utf-8'),
                                                        headers: {
                                                      'Authorization':
                                                          'Bearer ' + getToken()
                                                    });

                                                Navigator.pop(
                                                    context); //pop dialog
                                                _register(response);
                                              }
                                            })
                                        .paddingOnly(
                                            left: context.width() * 0.1,
                                            right: context.width() * 0.1),
                                    30.height,
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          decoration: boxDecorationRoundedWithShadow(30),
                          child: Icon(
                            Icons.person_add,
                            size: 60,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          )),
    ));
  }

  void _register(http.Response response) {
    if (response.statusCode == 201) {
      showSuccessfulAlertDialog(
          context, 'Success', 'Child account has been successfully created',
          () {
        finish(context);
        finish(context);
      });
    } else {
      showErrorAlertDialog(context, 'Failed', response.body,
          () => finish(context));
    }
  }
}
