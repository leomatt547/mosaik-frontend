import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic/constant.dart';
import 'package:mosaic/utils/response_message.dart';
import 'package:mosaic/widgets/circular_progress_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mosaic/models/childs.dart';
import 'package:http/http.dart' as http;
import '../screen/parent_registration_screen.dart';

Widget registerButton(context) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
      ),
      child: Text(
        "Create an Account",
        style: GoogleFonts.average(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: () {
        Route route = MaterialPageRoute(
            builder: (context) => const ParentRegistrationScreen());
        Navigator.push(context, route);
      },
    ),
  );
}

DialogButton cancelButton(context) {
  return DialogButton(
    child: Text("Cancel",
        style: GoogleFonts.average(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        )),
    onPressed: () {
      Navigator.pop(context);
    },
  );
}

DialogButton deleteAccountButton(context) {
  return DialogButton(
    color: Colors.red,
    child: Text("Delete",
        style: GoogleFonts.average(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        )),
    onPressed: () async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: circularProgresBar('Deleting account...'),
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
          );
        },
      );

      final response = await http.delete(
          Uri.parse(
              API_URL + '/parents/' + storage.read('parent_id').toString()),
          encoding: Encoding.getByName('utf-8'),
          headers: {'Authorization': 'Bearer ' + getToken()});

      if (response.statusCode == 204) {
        final getChildrenResponse = await http.get(
          Uri.parse(API_URL +
              '/childs?parent_id=' +
              storage.read('parent_id').toString()),
        );

        if (getChildrenResponse.statusCode == 200) {
          List<dynamic> extractedData = json.decode(getChildrenResponse.body);
          // ignore: unnecessary_null_comparison
          if (extractedData == null) {
            return;
          }
          List<Child> loadedChildren = [];
          loadedChildren = extractedData.map((dynamic childResponse) {
            String id = childResponse['id'].toString();
            String nama = childResponse['nama'];
            String email = childResponse['email'];
            return Child(id: id, nama: nama, email: email);
          }).toList();

          // ignore: avoid_function_literals_in_foreach_calls
          loadedChildren.forEach((Child child) async {
            await http.delete(
                Uri.parse(API_URL + "/childs/" + child.id.toString()),
                headers: {'Authorization': 'Bearer ' + storage.read('token')});
          });
        }

        storage.remove('token');
        Route route = MaterialPageRoute(
            builder: (context) => const ParentRegistrationScreen());
        Navigator.push(context, route);
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: responseMessage['alertTitle']['failed'],
          desc: responseMessage['alertDesc']['deleteAccount']['failed'],
          style: AlertStyle(
              titleStyle: GoogleFonts.average(
                fontWeight: FontWeight.w500,
              ),
              descStyle: GoogleFonts.average(
                fontWeight: FontWeight.w500,
              )),
          buttons: [
            cancelButton(context),
          ],
        ).show();
      }
    },
  );
}
