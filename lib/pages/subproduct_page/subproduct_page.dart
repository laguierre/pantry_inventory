import 'package:flutter/material.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/services/categories_firebase_services.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({
    super.key,
    required this.subCategory,
    required this.index,
    required this.category,
  });

  final String category, subCategory;
  final int index;

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  List<String> subCategoryCollection = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData(widget.category, widget.subCategory);
  }

  Future<void> fetchData(String category, String subcategory) async {
    print('$category - $subcategory');
    setState(() {
      subCategoryCollection = []; // Limpiar los datos existentes
      isLoading = true; // Mostrar indicador de carga
    });
    List<String> newData =
        await getSubcategoriesCollectionOnFirebase(category, subcategory);
    setState(() {
      subCategoryCollection =
          newData; // Actualizar los datos con los nuevos valores
      isLoading = false; // Ocultar indicador de carga
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text(widget.subCategory),
      ),
      body: Container(
        width: size.width,
        height: 200,
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
                itemCount: subCategoryCollection.length,
                itemBuilder: (contex, index) {
                  return Text(subCategoryCollection[index], style: TextStyle(color: Colors.white),);
                })
          ],
        ),
      ),
    );
  }
}
