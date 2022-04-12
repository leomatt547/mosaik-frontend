import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/login/login_screen.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:mosaic/widgets/dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/utils/widgets.dart';

class RegisterParentScreen extends StatefulWidget {
  static String tag = '/registerScreen';

  const RegisterParentScreen({Key? key}) : super(key: key);

  @override
  _RegisterParentScreenState createState() => _RegisterParentScreenState();
}

class _RegisterParentScreenState extends State<RegisterParentScreen> {
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
    return Scaffold(
      body: Container(
          width: context.width(),
          height: context.height(),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  50.height,
                  Text("Register Parent Account",
                      style: boldTextStyle(size: 24)),
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
                                        hint: 'Enter your full name here',
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
                                          hint: 'Enter your email here',
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
                                          hint: 'Enter your password here',
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
                                            text: "REGISTER",
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
                                                };

                                                String body = json.encode(data);

                                                final response =
                                                    await http.post(
                                                  Uri.parse(
                                                      API_URL + "/parents"),
                                                  body: body,
                                                  encoding: Encoding.getByName(
                                                      'utf-8'),
                                                );

                                                Navigator.pop(
                                                    context); //pop dia
                                                _register(response);
                                              }
                                            })
                                        .paddingOnly(
                                            left: context.width() * 0.1,
                                            right: context.width() * 0.1),
                                    30.height,
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Already have an account?',
                                            style: primaryTextStyle(
                                                color: Colors.grey)),
                                        4.width,
                                        Text('Log In Here',
                                                style: boldTextStyle(
                                                    color: primaryColor))
                                            .onTap(() {
                                          LoginScreen().launch(context);
                                        }),
                                      ],
                                    ).center(),
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
                            Icons.search,
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
    );
  }

  void _register(response) {
    if (response.statusCode == 201) {
      showSuccessfulAlertDialog(
          context, 'Success', 'Your account has been successfully created', () =>
        LoginScreen().launch(context));
    } else {
      showErrorAlertDialog(context, 'Failed', 'Oops, something has gone wrong',
          () => Navigator.pop(context));
    }
  }
}
