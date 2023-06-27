import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pantry_inventory/constants.dart';


class SubcategoryNameTitle extends StatelessWidget {
  const SubcategoryNameTitle(
      {super.key, required this.subCategoryName, required this.onPressed});

  final String subCategoryName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(subCategoryName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                    fontSize: size.width*0.055,
                    fontWeight: FontWeight.bold,
                    color: kBackgroundColor)),
            const Spacer(),
            IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kBackgroundColor,
                ))
          ],
        ));
  }
}
