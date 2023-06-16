import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PantryInventory extends ChangeNotifier {
  List<String> imageUrls = [];
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future<String> getCategoryImageUrls(String doc) async {
    String url = "N/A";
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(doc)
        .collection('photos')
        .doc('url')
        .get();

    if (snapshot.exists) {

      final documentData = snapshot.data();
      if (documentData != null && documentData.containsKey('url')) {
        url = documentData['url'];
      }
    }
    return url;
  }
  Future<List<String>> getCategoriesImageUrls(List<String> categories)  async {
    imageUrls = [];
    for(int i = 0; i < categories.length; i++){
      imageUrls.add(await getCategoryImageUrls(categories[i]));
    }
    return imageUrls;
  }
}
