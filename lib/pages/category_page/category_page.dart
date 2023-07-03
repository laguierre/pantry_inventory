import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/data/data.dart';
import 'package:pantry_inventory/models/categories_model.dart';
import 'package:pantry_inventory/pages/subproduct_page/subproduct_page.dart';
import 'package:pantry_inventory/services/categories_firebase_services.dart';
import 'package:pantry_inventory/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../add_category/add_category.dart';
import 'category_page_widgets.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage(
      {super.key, required this.categories, required this.index});

  final List<CategoryModel> categories;
  final int index;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 40, bottom: 15),
        height: 70,
        child: GlassmorphismContainer(
            widget: Row(
          children: [
            const Spacer(),
            SmoothPageIndicator(
                controller: titlePageController,
                count: widget.categories.length,
                effect: const ScrollingDotsEffect(
                    maxVisibleDots: 7,
                    activeDotColor: kBackgroundColor,
                    activeDotScale: 1.6,
                    spacing: 12),
                // your preferred effect
                onDotClicked: (index) {}),
            const Spacer(),
            FloatingActionButton(
              backgroundColor: kBackgroundColor,
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        opaque: true,
                        duration: const Duration(milliseconds: 300),
                        reverseDuration: const Duration(milliseconds: 300),
                        type: PageTransitionType.bottomToTop,
                        child: const AddCategory(title: 'Agregar categoría')));
              },
              child: Image.asset(plusImage, fit: BoxFit.fitHeight),
            ),
            const SizedBox(width: 15)
          ],
        )),
      ),
      body: Column(
        children: [
          const SizedBox(height: kPaddingTop),
          Expanded(
              child: PageView.builder(
            padEnds: false,
            controller: titlePageController,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            onPageChanged: (page) async {
              fetchData(widget.categories[page]
                  .nameCategory); // Volver a disparar el futuro al cambiar de página
            },
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 10),
                      height: 60,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                            splashRadius: 25,
                            padding: const EdgeInsets.only(left: 12.5),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 10),
                          CategoryName(widget: widget, index: index),
                        ],
                      )),
                  SubCategoryList(
                    isLoading: isLoading,
                    data: data,
                    category: widget.categories[index].nameCategory,
                    animateTrigger: !isLoading,
                  ),
                ],
              );
            },
          )),
        ],
      ),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  const SubCategoryList({
    super.key,
    required this.isLoading,
    required this.data,
    required this.category,
    required this.animateTrigger,
  });

  final bool isLoading;
  final Map<String, dynamic> data;
  final String category;
  final bool animateTrigger;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SlideInUp(
                from: MediaQuery.of(context).size.height + 500,
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 500),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      String key = data.keys.elementAt(i);
                      String value = data[key];
                      return SubcategoryNameTitle(
                        subCategoryName: value.toString(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  opaque: true,
                                  duration: const Duration(milliseconds: 100),
                                  reverseDuration:
                                      const Duration(milliseconds: 300),
                                  type: PageTransitionType.bottomToTop,
                                  child: SubCategoryPage(
                                      index: i,
                                      subCategory: key,
                                      category: category)));
                        },
                      );
                    },
                    separatorBuilder: (_, __) {
                      return Container(height: 1, color: Colors.grey);
                    },
                  ),
                ),
              ));
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
    var size = MediaQuery.of(context).size;
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
        Text(widget.categories[index].nameCategory.toUpperCase(),
            style: GoogleFonts.outfit(
                fontSize: size.height * 0.035,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
      ],
    );
  }
}
