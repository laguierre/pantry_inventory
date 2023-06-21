import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/data/data.dart';
import 'package:pantry_inventory/models/categories_model.dart';
import 'package:pantry_inventory/services/categories_firebase_services.dart';

import '../add_category/add_category.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage(
      {super.key, required this.categories, required this.index});

  final List<CategoryModel> categories;
  final int index;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late PageController titlePageController;
  Map<String, dynamic> data = {};
  bool isLoading = false;

  @override
  void initState() {
    titlePageController = PageController(viewportFraction: 1);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      titlePageController.animateToPage(
        widget.index,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
    fetchData(widget.categories[widget.index].nameCategory);
  }

  @override
  void dispose() {
    titlePageController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String subcategory) async {
    if (subcategory != "") {
      setState(() {
        data = {}; // Limpiar los datos existentes
        isLoading = true; // Mostrar indicador de carga
      });
      Map<String, dynamic> newData =
          await searchSubcategoriesOnFirebase(subcategory);
      setState(() {
        data = newData; // Actualizar los datos con los nuevos valores
        isLoading = false; // Ocultar indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBackgroundColor,
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  opaque: true,
                  duration: const Duration(milliseconds: 300),
                  reverseDuration: const Duration(milliseconds: 300),
                  type: PageTransitionType.rightToLeft,
                  child: const AddCategory(title: 'Agregar categoría')));
        },
        child: Image.asset(plusImage, fit: BoxFit.fitHeight),
      ),
      body: Column(
        children: [
          const SizedBox(height: 80),
          Container(
            padding: const EdgeInsets.only(left: 20),
            height: 60,
            child: PageView.builder(
              padEnds: false,
              reverse: false,
              controller: titlePageController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              onPageChanged: (page) async {
                fetchData(widget.categories[page]
                    .nameCategory); // Volver a disparar el futuro al cambiar de página
              },
              itemBuilder: (BuildContext context, int index) {
                return CategoryName(widget: widget, index: index);
              },
            ),
          ),
          Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        String key = data.keys.elementAt(i);
                        dynamic value = data[key];
                        return SubcategoryNameTitle(
                            subCategoryName: value.toString());
                      },
                      separatorBuilder: (_, __) {
                        return Container(
                            height: 1,
                            color: Colors.grey);
                      },
                    ))
        ],
      ),
    );
  }
}

class CategoryName extends StatelessWidget {
  const CategoryName({
    super.key,
    required this.widget,
    required this.index,
  });

  final CategoryPage widget;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.categories[index].urlCategoryImage != "N/A"
            ? ClipOval(
                child: ImageFade(
                    image:
                        NetworkImage(widget.categories[index].urlCategoryImage),
                    duration: const Duration(milliseconds: 500),
                    syncDuration: const Duration(milliseconds: 150),
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    placeholder:
                        Image.asset(avatarPlaceHolder, fit: BoxFit.fitWidth),
                    errorBuilder: (context, error) => Container(
                          color: const Color(0xFF6F6D6A),
                          alignment: Alignment.center,
                          child: Image.asset(avatarPlaceHolder,
                              color: Colors.white,
                              height: 35,
                              fit: BoxFit.fitHeight),
                        )))
            : Container(),
        const SizedBox(width: 20),
        Text(
          widget.categories[index].nameCategory.toUpperCase(),
          style: const TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class SubcategoryNameTitle extends StatelessWidget {
  const SubcategoryNameTitle({super.key, required this.subCategoryName});

  final String subCategoryName;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(
              subCategoryName,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                ))
          ],
        ));
  }
}
