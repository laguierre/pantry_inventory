import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/models/categories_model.dart';
import 'package:pantry_inventory/pages/login_page/login_page.dart';
import 'package:pantry_inventory/widgets.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key, required this.title});

  final String title;

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  TextEditingController addTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text(
          style: const TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          widget.title,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: size.height,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            children: [
              Flexible(
                child: CustomTextField(
                  textEditingController: addTextController,
                  textInputType: TextInputType.text,
                  hintText: 'Agregar categoría',
                  icon: Icons.emoji_food_beverage_outlined,
                ),
              ),
              const SizedBox(height: 20),
              WideButton(
                  backgroundColor: Colors.white,
                  titleColor: kBackgroundColor,
                  title: "Cargar Imagen",
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result == null) return;
                    setState(() {
                      pickedFile = result.files.first;
                    });
                  }),
              const SizedBox(height: 20),
              if (pickedFile != null)
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Image.file(
                      File(pickedFile!.path!),
                      width: double.infinity,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (pickedFile != null)
                WideButton(
                    backgroundColor: Colors.white,
                    titleColor: kBackgroundColor,
                    title: "Subir Imagen",
                    onPressed: () async {
                      String url = await uploadFile();
                      newCategory(url, addTextController.text);
                      Navigator.pop(context);
                    }),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadFile() async {
    final path = 'categories/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    debugPrint('Download Link: $urlDownload');
    setState(() {});
    return urlDownload;
  }

  Future<void> newCategory(String url, String newCategory) async {


    final docUser =
        FirebaseFirestore.instance.collection('categories').doc(newCategory);


    final categoryToSave =
        CategoryModel(nameCategory: newCategory, urlCategoryImage: url);
    final json = categoryToSave.toJson();

    ///Create document and write data to Firebase
    await docUser.set(json);
  }
}
