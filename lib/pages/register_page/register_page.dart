import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pantry_inventory/constants.dart';

import '../../widgets.dart';
import '../login_page/login_page.dart';

class RegisterPage extends StatelessWidget {
   RegisterPage({Key? key}) : super(key: key);

  TextEditingController nameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController confirmTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          BounceInLeft(
            delay: const Duration(milliseconds: 800),
            child: Align(
              alignment: const Alignment(-.8,-.8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const BackButton(color: Colors.white,),
                  const SizedBox(width: 5),
                  Text('Registrarse', style: GoogleFonts.outfit(
                      fontSize: 34, color: Colors.white))
                ],
              ),
            ),
          ),
          Container(
                margin: EdgeInsets.only(top: size.height * 0.20),
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
            decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre', style: GoogleFonts.outfit(
                      fontSize: 24, color: kBackgroundColor)),
                  const SizedBox(height: 15),
                  CustomTextField(
                    textEditingController: emailTextController,
                    hintText: 'Nombre',
                    icon: FontAwesomeIcons.user,
                  ),
                  const SizedBox(height: 15),

                  Text('Apellido', style: GoogleFonts.outfit(
                      fontSize: 24, color: kBackgroundColor)),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textEditingController: emailTextController,
                    hintText: 'Apellido',
                    icon: FontAwesomeIcons.houseUser,
                  ),
                  const SizedBox(height: 15),

                  Text('Edad', style: GoogleFonts.outfit(
                      fontSize: 24, color: kBackgroundColor)),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textEditingController: emailTextController,
                    hintText: 'Apellido',
                    icon: FontAwesomeIcons.calendar,
                  ),
                  const SizedBox(height: 15),

                  Text('Email*', style: GoogleFonts.outfit(
                      fontSize: 24, color: kBackgroundColor)),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textEditingController: emailTextController,
                    hintText: 'Ingrese su email...',
                    icon: FontAwesomeIcons.calendar,
                  ),
                  const SizedBox(height: 15),
                  Text('Password*', style: GoogleFonts.outfit(
                      fontSize: 24, color: kBackgroundColor)),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textEditingController: emailTextController,
                    hintText: 'Ingrese su Password...',
                    icon: FontAwesomeIcons.calendar,
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 15),
                  Text('Reingrese su Password*', style: GoogleFonts.outfit(
                      fontSize: 24, color: kBackgroundColor)),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textEditingController: emailTextController,
                    hintText: 'Reingrese su Password...',
                    icon: FontAwesomeIcons.calendar,
                  ),
                  const SizedBox(height: 45),
                  WideButton(
                      backgroundColor: kBackgroundColor,
                      titleColor: Colors.white,
                      title: 'Login',
                      onPressed: () {}),
                  const SizedBox(height: 15),
                  WideButton(
                      backgroundColor: kBackgroundColor,
                      titleColor: Colors.white,
                      title: 'Login con ',
                      isSignedGoogle: true,
                      onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
