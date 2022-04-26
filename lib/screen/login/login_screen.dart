import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/landing/landing_screen.dart';
import 'package:mosaic/screen/register_parent/register_parent_screen.dart';
import 'package:mosaic/screen/reset_password/forgot_password_screen.dart';
import 'package:mosaic/screen/update_password/update_password_screen.dart';
import 'package:mosaic/utils/jwt_helper.dart';
import 'package:mosaic/widgets/dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosaic/utils/widgets.dart';
import 'package:mosaic/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/loginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();

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
        body: Container(
          width: context.width(),
          height: context.height(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg1.jpg'), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  50.height,
                  Text("Login", style: boldTextStyle(size: 24)),
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          width: context.width(),
                          padding:
                              const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          margin: const EdgeInsets.only(top: 55.0),
                          decoration: boxDecorationWithShadow(
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                    ),
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
                                    ),
                                    16.height,
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text("Forgot password?",
                                              style: boldTextStyle(
                                                  color: primaryColor))
                                          .onTap(() => const ForgotPasswordScreen()
                                              .launch(context)),
                                    ),
                                    32.height,
                                    AppButton(
                                            text: "LOG IN",
                                            color: primaryColor,
                                            textColor: Colors.white,
                                            shapeBorder: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            width: context.width(),
                                            onTap: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                String email = emailController
                                                    .text
                                                    .toString();
                                                String password =
                                                    passwordController.text
                                                        .toString();

                                                Map data = {
                                                  'email': email,
                                                  'password': password,
                                                  'fcm': await FirebaseMessaging
                                                      .instance
                                                      .getToken(),
                                                };

                                                String body = json.encode(data);

                                                showLoading(
                                                    context, 'Processing...');

                                                final response =
                                                    await http.post(
                                                  Uri.parse(API_URL + "/login"),
                                                  body: body,
                                                  encoding: Encoding.getByName(
                                                      'utf-8'),
                                                );

                                                Navigator.pop(
                                                    context); //pop dialog
                                                _login(response);
                                              }
                                              // WAEditProfileScreen(isEditProfile: false).launch(context);
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
                                        Text('Don\'t have an account?',
                                            style: primaryTextStyle(
                                                color: Colors.grey)),
                                        4.width,
                                        Text('Register Here',
                                                style: boldTextStyle(
                                                    color: primaryColor))
                                            .onTap(() {
                                          const RegisterParentScreen()
                                              .launch(context);
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
                          child: const Icon(
                            Icons.search,
                            size: 60,
                          ),
                        )
                      ],
                    ),
                  ),
                  16.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login(response) {
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      bool isChange = responseBody['Details']['is_change'];
      print(isChange);
      String jwt = responseBody['Token'];
      storage.write('token', jwt);

      // Extract parent_id from token
      Map<String, dynamic> jwtPayload = JwtHelper.parseJwtPayLoad(jwt);
      storage.write('parent_id', jwtPayload['parent_id']);
      storage.write('child_id', jwtPayload['child_id']);

      if (isChange) {
        const UpdatePasswordScreen().launch(context);
      } else {
        const LandingScreen().launch(context);
      }

    } else {
      showErrorAlertDialog(context, 'Invalid Credentials',
          'Wrong email or password', () => Navigator.pop(context));
    }
  }
}
