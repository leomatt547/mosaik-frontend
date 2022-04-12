import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/screen/change_password_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic/utils/colors.dart';
import 'package:mosaic/utils/widgets.dart';
import 'package:mosaic/widgets/dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mosaic/widgets/form.dart';
import 'package:nb_utils/nb_utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    _getUserData();

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Edit Profile',
            style: boldTextStyle(color: Colors.black, size: 20),
          ),
          leading: Container(
            margin: EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Icon(Icons.arrow_back, color: Colors.black,),
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
                  image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
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
                                hint: 'Enter your full name here',
                              ),
                              textFieldType: TextFieldType.NAME,
                              keyboardType: TextInputType.name,
                              controller: nameController,
                              focus: nameFocusNode,
                            ),
                            16.height,
                            Text('Email', style: boldTextStyle(size: 14)),
                            8.height,
                            AppTextField(
                              decoration: inputDecoration(
                                hint: 'Enter your email here',
                              ),
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
                        color: Color(0xFFFF7426),
                        width: context.width() * 0.8,
                        child: Text('CHANGE PASSWORD',
                            style: boldTextStyle(color: Colors.white)),
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30)),
                        onTap: () {},
                      ).center(),
                      16.height,
                      AppButton(
                        color: primaryColor,
                        width: context.width() * 0.8,
                        child: Text('SAVE',
                            style: boldTextStyle(color: Colors.white)),
                        shapeBorder: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30)),
                        onTap: () {},
                      ).center()
                    ],
                  ),
                ),
              ),
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: Icon(Icons.person, color: primaryColor, size: 60),
                  ),
                  Positioned(
                    bottom: 16,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.edit, color: Colors.white, size: 20),
                      decoration: BoxDecoration(
                          color: primaryColor, shape: BoxShape.circle),
                    ),
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
      Alert(
        context: context,
        type: AlertType.success,
        title: "Success",
        desc: "Your profile has been successfully changed",
        buttons: [
          DialogButton(
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show();
    } else {}
  }

  Future<void> _getUserData() async {
    String url;

    if (storage.read('parent_id') != null) {
      url = API_URL + '/parents/${storage.read('parent_id')}';
    } else if (storage.read('child_id') != null) {
      url = API_URL + '/parents/${storage.read('child_id')}';
    } else {
      showErrorAlertDialog(context, 'Failed', 'Oops, something has gone wrong',
          () => Navigator.pop(context));
      return;
    }

    final response = await http.get(Uri.parse(url));

    var extractedData = json.decode(response.body);
    // print('${extractedData['id']}, ${extractedData['nama']}, ${extractedData['email']}');
    print('Test');

    if (extractedData == null) {
      return;
    }

    if (extractedData['nama'] != null && extractedData['email'] != null) {
      nameController.text = extractedData['nama'];
      emailController.text = extractedData['email'];
    }
  }
}
