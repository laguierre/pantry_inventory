import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_fade/image_fade.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/services/register_firebase.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Obtiene el usuario que está conectado
  final user = FirebaseAuth.instance.currentUser;

//documents IDs
  List<String> docIDs = [];

  ///Obtiene todos los usuarios almacenados en USERS
  Future getDocId() async {
    //docIDs.clear();
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach((document) {
            docIDs.add(document.reference.id);
          }),
        );
    print(docIDs);
  }

  @override
  Widget build(BuildContext context) {
    print(user);
    String urlPhoto = user!.photoURL ?? 'lib/assets/images/avatar.png';
    getDocId();
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,

      appBar: AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                    child: ImageFade(
                        height: 45,
                        width: 45,
                        image: NetworkImage(urlPhoto),
                        duration: const Duration(milliseconds: 500),
                        syncDuration: const Duration(milliseconds: 150),
                        alignment: Alignment.center,
                        fit: BoxFit.scaleDown,
                        placeholder: Image.asset('lib/assets/images/avatar.png',
                            fit: BoxFit.fitWidth),
                        errorBuilder: (context, error) => Container(
                              color: const Color(0xFF6F6D6A),
                              alignment: Alignment.center,
                              child: Image.asset('lib/assets/images/avatar.png',
                                  color: Colors.white,
                                  height: 35,
                                  fit: BoxFit.fitHeight),
                            ))),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    Text(
                      user!.displayName ?? 'N/A',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text('${user!.email}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                const Spacer(),
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 35,

                    ), onPressed: () {
                  firebaseSignUserOut();

                })
              ],
            ),
          )),
      body: Column(
        children: [],
      ),
    );
  }
}
