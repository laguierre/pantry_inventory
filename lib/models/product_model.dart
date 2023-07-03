import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  int qtyToBuy;
  double price;
  double pricePerUnit;
  String presentation;
  int stock;
  String subType;
  String subCategory;
  String category;
  String urlPhoto;
  String unit;
  String brand;
  int id;

  ProductModel({
    required this.qtyToBuy,
    required this.brand,
    required this.price,
    required this.pricePerUnit,
    required this.presentation,
    required this.stock,
    required this.subType,
    required this.subCategory,
    required this.category,
    required this.urlPhoto,
    required this.unit,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'comprar': qtyToBuy,
        'precio': price,
        'precioxunitario': pricePerUnit,
        'presentacion': presentation,
        'stock': stock,
        'subtipo': subType,
        'tipo': subCategory,
        'category': category,
        'urlPhoto': urlPhoto,
        'unidad': unit,
        'marca': brand,
        'id': id,
      };

  static ProductModel fromJson(Map<String, dynamic> json) => ProductModel(
        qtyToBuy: json['comprar'] ?? 0,
        price: json['precio'] ?? 0.0,
        pricePerUnit: json['precioxunitario'] ?? 0.0,
        presentation: json['presentacion'] ?? "N/A",
        stock: json['stock'] ?? 0,
        subType: json['subtipo'] ?? "N/A",
        subCategory: json['tipo'] ?? "N/A",
        category: json['category'] ?? "N/A",
        urlPhoto: json['urlPhoto'] ?? "N/A",
        unit: json['unidad'] ?? "N/A",
        brand: json['marca'] ?? "N/A",
        id: json['id'] ?? 0,
      );

  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null) {
      return ProductModel.fromJson(data);
    } else {
      // Manejo de error si no se encontraron datos
      throw Exception('No se encontraron datos');
    }
  }
}
