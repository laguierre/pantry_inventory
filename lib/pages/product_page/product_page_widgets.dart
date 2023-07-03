import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pantry_inventory/constants.dart';

import '../login_page/login_page.dart';

class InfoLineAndEdit extends StatefulWidget {
  const InfoLineAndEdit(
      {super.key,
      required this.noBoldText,
      required this.boldText,
      required this.sizeText,
      required this.onPressed});

  final String noBoldText, boldText;
  final double sizeText;
  final VoidCallback onPressed;

  @override
  State<InfoLineAndEdit> createState() => _InfoLineAndEditState();
}

class _InfoLineAndEditState extends State<InfoLineAndEdit> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(widget.noBoldText,
          style: GoogleFonts.outfit(
              fontSize: widget.sizeText,
              fontWeight: FontWeight.normal,
              color: kBackgroundColor)),
      GestureDetector(
        onLongPress: widget.onPressed,
        child: Text(widget.boldText,
            style: GoogleFonts.outfit(
                fontSize: widget.sizeText,
                fontWeight: FontWeight.bold,
                color: kBackgroundColor)),
      ),
    ]);
  }
}

Future<String> openPopup(String textToChange, TextInputType keyboardType,
    BuildContext context, TextEditingController textEditingController) async {
  final result = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      var size = MediaQuery.of(context).size;
      String updatedText = textToChange;
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0))),
        content: SizedBox(
          width: size.width * 0.9,
          height: size.height * 0.23,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar Texto',
                style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kBackgroundColor),
              ),
              const SizedBox(height: 25),
              TextField(
                keyboardType: keyboardType,
                controller: textEditingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                    borderSide: BorderSide(
                      color: kBackgroundColor,
                      width: 10,
                      style: BorderStyle.none,
                    ),
                  ),
                  hintText: 'Ingresa el texto',
                  hintStyle: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  isDense: true,
                ),
                onChanged: (value) {
                  updatedText = value;
                },
                style:
                    GoogleFonts.outfit(fontSize: 24, color: kBackgroundColor),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: size.width * 0.3,
                      child: WideButton(
                          fontSize: 15,
                          title: 'Cancelar',
                          onPressed: () {
                            Navigator.of(context).pop();
                          })),
                  SizedBox(
                      width: size.width * 0.3,
                      child: WideButton(
                          backgroundColor: Colors.red,
                          fontSize: 15,
                          title: 'Guardar',
                          onPressed: () {
                            textToChange = updatedText;
                            Navigator.of(context).pop(updatedText);
                          })),
                ],
              )
            ],
          ),
        ),
      );
    },
  );

  if (result != null) {
    return result;
  } else {
    return textToChange;
  }
}
