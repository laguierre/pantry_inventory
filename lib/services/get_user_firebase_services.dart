import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantry_inventory/models/user_model.dart';

Future<UserModel?> readUserDataFromFirebase(String documentId) async {
  UserModel? userModel;
  try {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .get();

    if (documentSnapshot.exists) {
      debugPrint('Documento encontrado: ${documentSnapshot.data()}');
      return UserModel.fromJson(documentSnapshot.data()!);
    } else {
      debugPrint('El documento no existe');
    }
  } catch (e) {
    debugPrint('Error al leer el documento: $e');
  }
  return userModel;
}

int checkAuthMethod() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    List<String> providers =
        user.providerData.map((userInfo) => userInfo.providerId).toList();
    if (providers.contains('password')) {
      return 0;
    }
    if (providers.contains('google.com')) {
      return 1;
    }
  } else {
    debugPrint('El usuario no está autenticado.');
  }
  return -1;
}
