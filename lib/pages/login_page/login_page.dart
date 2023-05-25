import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pantry_inventory/pages/register_page/register_page.dart';
import 'package:pantry_inventory/widgets.dart';

import '../../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passTextController = TextEditingController();
  TextEditingController confirmPassTextController = TextEditingController();
  bool isFinishContainer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    emailTextController.dispose();
    passTextController.dispose();
    confirmPassTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var dg = sqrt(size.height * size.height + size.width * size.width);
    double titleSize = dg * 0.071;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            // image: DecorationImage(
            //     colorFilter: ColorFilter.mode(Colors.white70, BlendMode.color),
            //     image: AssetImage(backgroundImage),
            //     fit: BoxFit.cover),
            color: kBackgroundColor,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              //TitleApp(titleSize: titleSize),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SlideInUp(
                      child: WideButton(
                        backgroundColor: kRedColorButton,
                        titleColor: Colors.white,
                        title: 'Registrarse',
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                                context,
                                PageTransition(
                                  opaque: true,
                                  duration: const Duration(milliseconds: 800),
                                    type: PageTransitionType.bottomToTop,
                                    child: RegisterPage()));
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SlideInUp(
                      duration: const Duration(milliseconds: 800),
                      child: WideButton(
                        backgroundColor: Colors.white,
                        titleColor: kBackgroundColor,
                        title: 'Ingresar',
                        onPressed: () {
                          controller.forward();

                        },
                      ),
                    )
                  ],
                ),
              ),
              AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Container(
                      height: animation.value * size.height * 0.8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onVerticalDragUpdate: (details) {
                                int sensitivity = 8;
                                if (details.delta.dy < sensitivity) {
                                  controller.reverse();
                                }
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(150, 15, 150, 0),
                                height: 5,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(3)),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Bienvenido nuevamente!',
                              style: GoogleFonts.outfit(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: kBackgroundColor),
                            ),
                            const SizedBox(height: 50),
                            Text(
                              'Email*',
                              style: GoogleFonts.outfit(
                                  fontSize: 22, color: kBackgroundColor),
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              textEditingController: emailTextController,
                              hintText: 'Ingrese su email...',
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Password*',
                              style: GoogleFonts.outfit(
                                  fontSize: 22, color: kBackgroundColor),
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              textEditingController: emailTextController,
                              hintText: 'Password',
                              icon: Icons.lock_outline,
                            ),
                            SizedBox(height: size.height * 0.10),
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
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Spacer(),
                                Text(
                                  'No tiene cuenta? ',
                                  style: GoogleFonts.outfit(
                                      fontSize: 18, color: kBackgroundColor),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isFinishContainer = true;
                                    });
                                    controller.reverse().then((value) => Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.bottomToTop,
                                            child: RegisterPage())));
                                  },
                                  child: Text(
                                    'Registrese.',
                                    style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        color: kBackgroundColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class WideButton extends StatelessWidget {
  const WideButton(
      {super.key,
      required this.backgroundColor,
      required this.titleColor,
      required this.title,
      required this.onPressed,
      this.isSignedGoogle = false});

  final Color backgroundColor;
  final Color titleColor;
  final String title;
  final VoidCallback onPressed;
  final bool isSignedGoogle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 15),
        height: 40,
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                  fontSize: 20, fontWeight: FontWeight.bold, color: titleColor),
            ),
            if (isSignedGoogle) const SizedBox(width: 5),
            if (isSignedGoogle) Icon(FontAwesomeIcons.google, color: titleColor)
          ],
        ),
      ),
    );
  }
}

class TitleApp extends StatelessWidget {
  const TitleApp({
    super.key,
    required this.titleSize,
  });

  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey.withOpacity(0.7),
      ),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'M',
              style: GoogleFonts.merriweather(
                fontSize: titleSize,
                fontWeight: FontWeight.w500,
                color: titleColor,
                textStyle: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            TextSpan(
              text: 'Stock',
              style: GoogleFonts.outfit(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: titleColor),
            ),
          ],
        ),
      ),
    );
  }
}

