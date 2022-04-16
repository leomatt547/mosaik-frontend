import 'package:flutter/material.dart';
import 'package:mosaic/utils/colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void showLoading(context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          width: 300.0,
          height: 200.0,
          alignment: AlignmentDirectional.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                    color: primaryColor,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(msg),
                ),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
      );
    },
  );
}

void showSuccessfulAlertDialog(context, String title, String desc, void Function() onPressed) {
  Alert(
    context: context,
    type: AlertType.success,
    title: title,
    desc: desc,
    style: const AlertStyle(
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        )
    ),
    buttons: [
      DialogButton(
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.white),
        ),
        radius: BorderRadius.circular(30),
        onPressed: onPressed,
        color: primaryColor,
      )
    ],
  ).show();
}

void showErrorAlertDialog(context, String title, String desc, void Function() onPressed) {
  Alert(
    context: context,
    type: AlertType.error,
    title: title,
    desc: desc,
    style: const AlertStyle(
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        descStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        )
    ),
    buttons: [
      DialogButton(
        child: const Text(
          "OK",
          style: TextStyle(color: Colors.white),
        ),
        radius: BorderRadius.circular(30),
        onPressed: onPressed,
        width: 120,
        color: primaryColor,
      )
    ],
  ).show();

}