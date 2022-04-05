import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Container circularProgresBar(text) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.grey[200], borderRadius: BorderRadius.circular(10.0)),
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
              color: Colors.black,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25.0),
          child: Center(
            child: Text(text,
                style: GoogleFonts.average(
                  fontWeight: FontWeight.w700,
                )),
          ),
        ),
      ],
    ),
  );
}
