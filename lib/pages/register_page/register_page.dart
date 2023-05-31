import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/models/user_model.dart';
import 'package:pantry_inventory/services/register_firebase.dart';
import 'package:pantry_inventory/services/register_google.dart';

import '../../widgets.dart';
import '../login_page/login_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController confirmTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool isSwitch = true;

  @override
  void dispose() {
    nameTextController.dispose();
    lastNameTextController.dispose();
    ageTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmTextController.dispose();
    super.dispose();
  }

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
              alignment: const Alignment(-.8, -.8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const BackButton(
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text('Registro',
                      style: GoogleFonts.outfit(
                          fontSize: 34, color: Colors.white)),
                  const Spacer(),
                  CupertinoSwitch(
                    trackColor: Colors.white38,
                    value: isSwitch,
                    onChanged: (bool value) {
                      setState(() {
                        isSwitch = value;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.20),
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30))),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('(*) Campos obligatorios',
                          style: GoogleFonts.outfit(
                              fontSize: 14, color: kBackgroundColor))
                    ],
                  ),
                  Text('Nombre*',
                      style: GoogleFonts.outfit(
                          fontSize: 24, color: kBackgroundColor)),
                  const SizedBox(height: 15),
                  CustomTextField(
                    textEditingController: nameTextController,
                    hintText: 'Nombre',
                    icon: FontAwesomeIcons.user,
                  ),
                  const SizedBox(height: 15),
                  Text('Apellido*',
                      style: GoogleFonts.outfit(
                          fontSize: 24, color: kBackgroundColor)),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textEditingController: lastNameTextController,
                    hintText: 'Apellido',
                    icon: FontAwesomeIcons.houseUser,
                  ),
                  const SizedBox(height: 15),
                  Text('Edad',
                      style: GoogleFonts.outfit(
                          fontSize: 24, color: kBackgroundColor)),
                  const SizedBox(height: 10),
                  CustomTextField(
                    textEditingController: ageTextController,
                    textInputType: TextInputType.number,
                    hintText: 'Edad',
                    icon: FontAwesomeIcons.calendar,
                  ),
                  Visibility(
                      visible: !isSwitch,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text('Email*',
                              style: GoogleFonts.outfit(
                                  fontSize: 24, color: kBackgroundColor)),
                          const SizedBox(height: 10),
                          CustomTextField(
                            textEditingController: emailTextController,
                            hintText: 'Ingrese su email...',
                            textInputType: TextInputType.emailAddress,
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 10),
                          Text('Password*',
                              style: GoogleFonts.outfit(
                                  fontSize: 24, color: kBackgroundColor)),
                          const SizedBox(height: 10),
                          CustomTextField(
                            obscureText: true,
                            textEditingController: passwordTextController,
                            hintText: 'Ingrese su Password...',
                            icon: FontAwesomeIcons.key,
                          ),
                          const SizedBox(height: 15),
                          Text('Reingrese su Password*',
                              style: GoogleFonts.outfit(
                                  fontSize: 24, color: kBackgroundColor)),
                          const SizedBox(height: 10),
                          CustomTextField(
                            obscureText: true,
                            textEditingController: confirmTextController,
                            hintText: 'Reingrese su Password...',
                            icon: FontAwesomeIcons.key,
                          ),
                        ],
                      )),
                  const SizedBox(height: 45),
                  WideButton(
                      backgroundColor: kBackgroundColor,
                      titleColor: Colors.white,
                      title: !isSwitch ? 'Registrarse' : 'Login con ',
                      isSignedGoogle: isSwitch,
                      onPressed: () {

                        if (isSwitch) {
                          if (_checkDataNameAndLastName()) {
                            UserModel user = UserModel(
                              email: emailTextController.text ?? "",
                              name: nameTextController.text,
                              lastName: lastNameTextController.text,
                              age: int.parse(ageTextController.text),
                            );

                            AuthService().signInWithGoogle();
                            final userGoogle = FirebaseAuth.instance.currentUser;
                            user.email = userGoogle!.email!;
                            addUserDetailsToFirebase(user);
                          }
                        } else {
                          _checkDataSignInWithEmailAndPassword();
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _checkDataNameAndLastName() {
    if (nameTextController.text.isEmpty ||
        lastNameTextController.text.isEmpty) {
      showAlert(context, 'Error', 'Contenido vacío Nombre o Apellido', Icons.error);
      return false;
    }
    return true;
  }

  bool _checkDataSignInWithEmailAndPassword() {
    _checkDataNameAndLastName();
    if (passwordTextController.text != confirmTextController.text) {
      showAlert(context, 'Error', 'El Password debe ser igual en ambos campos.',
          Icons.error);
      return false;
    }
    if (nameTextController.text.isEmpty ||
        lastNameTextController.text.isEmpty) {
      showAlert(
          context, 'Error', 'El Nombre o el Apellido está vacío', Icons.error);
      return false;
    }
    UserModel user = UserModel(
      email: emailTextController.text,
      name: nameTextController.text,
      lastName: lastNameTextController.text,
      age: int.parse(ageTextController.text),
    );
    registerNewUserWithEmailAndPassword(
        emailTextController.text, passwordTextController.text);
    addUserDetailsToFirebase(user);
    return true;
  }
}
