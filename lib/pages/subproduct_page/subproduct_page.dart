import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/data/data.dart';
import 'package:pantry_inventory/pages/add_category/add_category.dart';
import 'package:pantry_inventory/services/categories_firebase_services.dart';
import 'package:pantry_inventory/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

class _SubCategoryPageState extends State<SubCategoryPage>
    with TickerProviderStateMixin {
  List<String> subCategoryCollection = [];
  PageController pageController = PageController();
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
    await getSubcategoriesFieldsOnFirebase(category, subcategory);
    setState(() {
      subCategoryCollection =
          newData; // Actualizar los datos con los nuevos valores
      print(subCategoryCollection);
      isLoading = false; // Ocultar indicador de carga
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
          title: Text(
              ('${widget.category} / ${widget.subCategory}').toUpperCase())),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 40, bottom: 15),
        height: 70,
        child: GlassmorphismContainer(
            widget: Row(
          children: [
            const Spacer(),
            SmoothPageIndicator(
                controller: pageController,
                count: subCategoryCollection.length,
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
                        type: PageTransitionType.rightToLeft,
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
          Expanded(
            child: PageView.builder(
              onPageChanged: (page) async {
                //TODO Cambio de Pagina
              },
              controller: pageController,
              scrollDirection: Axis.horizontal,
              itemCount: subCategoryCollection.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                print(subCategoryCollection);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 20),
                        height: 60,
                        child: Text(
                          subCategoryCollection.elementAt(index).toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
