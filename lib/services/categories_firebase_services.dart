import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/categories_model.dart';


/// Obtiene las categorias almacenadas en la base de datos
Stream<List<CategoryModel>> searchCategoriesOnFirebase() {
  Stream<List<CategoryModel>> categories;
  categories = FirebaseFirestore.instance
      .collection('categories')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList());
  return categories;
}

///Devuelve la subcategoria dada uma categoría. Las mismas son variables
/*Stream<Map<String, dynamic>> searchSubcategoriesOnFirebase(String subCategory) {
  try {
    var query = FirebaseFirestore.instance
        .collection('subcaterogy')          //está mal escrito
        .doc(subCategory)
        .snapshots();

    return query.map((documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        return data;
      } else {
        return {};
      }
    });
  } catch (e) {
    print('Error searching subcategories on Firebase: $e');
    return const Stream.empty();
  }
}*/

///Devuelve la subcategoria dada uma categoría. Las mismas son variables
Future<Map<String, dynamic>> searchSubcategoriesOnFirebase(String subCategory) async {
  try {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection('subcaterogy')
        .doc(subCategory)
        .get();

    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>;
      return data;
    } else {
      return {};
    }
  } catch (e) {
    debugPrint('Error searching subcategories on Firebase: $e');
    return {};
  }
}