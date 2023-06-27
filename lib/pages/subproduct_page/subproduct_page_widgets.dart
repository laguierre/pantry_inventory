import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pantry_inventory/constants.dart';


class NoProduct extends StatelessWidget {
  const NoProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('No hay productos',
              style: GoogleFonts.outfit(
                fontSize: 24,
                color: kBackgroundColor,
              )),
          const SizedBox(height: 20),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Image.asset(iconNoFood)),
        ],
      ),
    );
  }
}
