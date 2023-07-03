import 'package:flutter/material.dart';
import 'package:pantry_inventory/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  late String _brand;
  late double _price;
  late double _pricePerUnit;
  late String _presentation;
  late String _urlPhoto;
  late int _stock;
  late int _qtyToBuy;
  late String _unit;
  late String _category;
  late String _subCategory;
  late String _subType;
  late int _id;

  String get brand => _brand;

  double get price => _price;

  int get id => _id;

  double get pricePerUnit => _pricePerUnit;

  String get presentation => _presentation;

  String get unit => _unit;

  String get urlPhoto => _urlPhoto;

  int get stock => _stock;

  int get qtyToBuy => _qtyToBuy;

  String get subCategory => _subCategory;

  String get subType => _subType;

  String get category => _category;

  set brand(String value) {
    _brand = value;
    notifyListeners();
  }

  set id(int value) {
    _id = value;
    notifyListeners();
  }

  set category(String value) {
    _category = value;
    notifyListeners();
  }

  set subType(String value) {
    _subType = value;
    notifyListeners();
  }

  set subCategory(String value) {
    _subCategory = value;
    notifyListeners();
  }

  set price(double value) {
    _price = value;
    notifyListeners();
  }

  set pricePerUnit(double value) {
    _pricePerUnit = value;
    notifyListeners();
  }

  set presentation(String value) {
    _presentation = value;
    notifyListeners();
  }

  set urlPhoto(String value) {
    _urlPhoto = value;
    notifyListeners();
  }

  set stock(int value) {
    _stock = value;
    notifyListeners();
  }

  set qtyToBuy(int value) {
    _qtyToBuy = value;
    notifyListeners();
  }

  set unit(String unit) {
    _unit = unit;
    notifyListeners();
  }

  void setProductInfo(ProductModel product, String category, String subCategory,
      String subCategoryCollection) {
    _brand = product.brand;
    _qtyToBuy = product.qtyToBuy;
    _price = product.price;
    _pricePerUnit = product.pricePerUnit;
    _presentation = product.presentation;
    _stock = product.stock;
    _urlPhoto = product.urlPhoto;
    _unit = product.unit;
    _category = category;
    _subCategory = subCategory;
    _subType = subCategoryCollection;
    _id = product.id;
  }
}
