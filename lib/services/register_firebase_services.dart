import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantry_inventory/widgets.dart';

import '../models/user_model.dart';

Future<void> firebaseSignUserIn(
    BuildContext context, String email, String password) async {
  showDialog(
      context: context,
      builder: (_) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      });
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);

    if (e.code == 'user-not-found') {
      showAlert(context, 'Error', 'Email incorrecto', Icons.error);
    } else if (e.code == 'wrong-password') {
      showAlert(context, 'Error', 'Password incorrecto', Icons.error);
    }
  }
}

Future<User?> registerNewUserWithEmailAndPassword(
    String email, String password) async {
  User? user;

  ///Create user
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());
    user = userCredential.user;
  } catch (e) {
    debugPrint('Error al registrar el usuario: $e');
  }
  return user;
}

///Add User deteails
Future addUserDetailsToFirebase(UserModel user) async {
  await FirebaseFirestore.instance.collection('users').doc(user.userToken).set({
    'name': user.name,
    'lastname': user.lastName,
    'age': user.age,
    'email': user.email,
    'userToken': user.userToken,
  });
}

Future<void> passwordReset(BuildContext context, String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent!. Please check your mail'),
          );
        });
  } on FirebaseAuthException catch (e) {
    ///Si el usuario no existe da un error
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        });
  }
}

Future<void> firebaseSignUserOut() async {
  FirebaseAuth.instance.signOut();
}
