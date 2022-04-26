import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mosaic/constant.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/utils/colors.dart';
import 'package:mosaic/utils/widgets.dart';
import 'package:mosaic/widgets/dialog.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

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
            'Forgot Password',
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
                      Text(
                        'Enter your registered email below to receive password reset instruction via email',
                        style: primaryTextStyle(),
                        textAlign: TextAlign.center,
                      ).center(),
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
                            Text('Email', style: boldTextStyle(size: 14)),
                            8.height,
                            AppTextField(
                              decoration: inputDecoration(
                                  hint: 'Enter your email here',
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
                        color: primaryColor,
                        width: context.width() * 0.8,
                        child: Text('SEND',
                            style: boldTextStyle(color: Colors.white)),
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            showLoading(context, 'Loading...');

                            Map data = {
                              'email': emailController.text.toString(),
                            };

                            String body = json.encode(data);
                            String url = API_URL + '/resetpassword';

                            final response = await http.post(
                              Uri.parse(url),
                              body: body,
                              encoding: Encoding.getByName('utf-8'),
                            );

                            Navigator.pop(context); // pop dialog
                            _send(response);
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

  void _send(response) {
    if (response.statusCode == 200) {
      showSuccessfulAlertDialog(
          context,
          'Check your email',
          'We\'ve sent you a new password to your email',
          () => finish(context));
    } else {
      showErrorAlertDialog(context, 'Failed',
          'This email is not registered as a parent', () => finish(context));
    }
  }

}
