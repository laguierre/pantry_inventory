import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pantry_inventory/models/product_model.dart';
import '../constants.dart';
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
Future<Map<String, dynamic>> searchSubcategoriesOnFirebase(
    String subCategory) async {
  try {
    var documentSnapshot = await FirebaseFirestore.instance
        .collection(subcategoryCollection)
        .doc(subCategory)
        .get();

    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>;
      //Ordenado alfabeticamente
      return Map.fromEntries(
          data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    } else {
      return {};
    }
  } catch (e) {
    debugPrint('Error searching subcategories on Firebase: $e');
    return {};
  }
}

///Obtiene los valores de los elementos que tiene una subcategoría
///colección: subcategory, documento: almacen, subcolleccion: aceites
Future<List<String>> getSubcategoriesCollectionOnFirebase(
    String category, String subCategory) async {
  try {
    print(subCategory);
    var querySnapshot = await FirebaseFirestore.instance
        .collection(subcategoryCollection)
        .doc(category)
        .collection(subCategory)
        .get();

    return querySnapshot.docs.map((documentSnapshot) {
      return documentSnapshot.id;
    }).toList();
  } catch (e) {
    debugPrint('Error searching subcategories on Firebase: $e');
    return [];
  }
}

///Obtiene los valores de los almacenados que tiene una subcategoría
///colección: subcategory, documento: almacen, subcolleccion: aceites
Future<List<ProductModel>> getSubcategoriesFieldsOnFirebase(
    String category, String subCategory, String subType) async {

  DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection(subcategoryCollection)
      .doc(category)
      .collection(subCategory)
      .doc(subType)
      .get();

  Map<String, dynamic>? data = snapshot.data();
  if (data != null) {
    List<ProductModel> products = [];
    data.forEach((key, value) {
      ProductModel product = ProductModel.fromJson(value);
      products.add(product);
    });
    return products;
  } else {
    return []; // Return an empty list if no data is found
  }
}
