import 'package:flutter/material.dart';
import 'package:mosaic/screen/browsing_screen.dart';
import 'package:mosaic/utils/widgets.dart';
import 'package:mosaic/widgets/appbar.dart';
import 'package:nb_utils/nb_utils.dart';

class LandingScreen extends StatefulWidget {
  static String tag = '/landingScreen';

  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  var textFieldController = TextEditingController();
  FocusNode textFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(),
          body: Container(
            width: context.width(),
            height: context.height(),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search,
                      size: 64,
                    ),
                    Text(
                      'Mosaik',
                      style: TextStyle(
                        fontSize: 48,
                        backgroundColor: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Flexible(
                        child: AppTextField(
                          decoration: inputDecoration(
                              hint: 'Type web address',
                              prefixIcon: Icons.search),
                          textFieldType: TextFieldType.EMAIL,
                          keyboardType: TextInputType.emailAddress,
                          controller: textFieldController,
                          focus: textFocusNode,
                          onFieldSubmitted: (term) {
                            _sendDataToSecondScreen(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _sendDataToSecondScreen(BuildContext context) {
    String textToSend = textFieldController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrowsingScreen(textToSend),
        ));
  }
}
