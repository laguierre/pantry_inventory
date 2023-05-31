import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType textInputType;

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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Por favor, ingresa una contraseña.';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres.';
              }
              return null; // La validación es correcta
            },
            obscureText: obscureText,
            controller: textEditingController,
            keyboardType: textInputType,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.grey,
                size: 22,
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
            style: GoogleFonts.outfit(fontSize: 24, color: kBackgroundColor)),
      ),
    );
  }
}

///Show Custom Dialog
void showAlert(
    BuildContext context, String textTitle, String contentText, IconData icon) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          elevation: 10,
          title: Row(
            children: [
              Icon(icon, size: 24, color: kBackgroundColor),
              const SizedBox(width: 5),
              Text(textTitle,
                  style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kBackgroundColor)),
            ],
          ),
          content: Text(contentText,
              textAlign: TextAlign.justify,
              style: GoogleFonts.outfit(fontSize: 18, color: kBackgroundColor)),
          actions: [
            MaterialButton(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: 30,
                color: kBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: GoogleFonts.outfit(fontSize: 18, color: Colors.white),
                )),
          ],
        );
      });
}
