import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
        required this.textEditingController,
        required this.hintText,
        required this.icon})
      : super(key: key);

  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 60,
      //margin: const EdgeInsets.fromLTRB(20, 45, 20, 0),
      //padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        /*boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],*/
        //border: Border.all(color: kSearchColorTextField, width: 2),
          borderRadius: BorderRadius.circular(7),
          color: kTextEditColor),
      child: SizedBox(
        width: double.infinity,
        child: TextFormField(
            controller: textEditingController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.grey,
                size: 30,
              ),
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              isDense: true,
            ),
            style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kBackgroundColor)),
      ),
    );
  }
}