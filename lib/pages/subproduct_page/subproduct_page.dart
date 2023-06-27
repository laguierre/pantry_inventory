import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/data/data.dart';
import 'package:pantry_inventory/models/product_model.dart';
import 'package:pantry_inventory/pages/add_category/add_category.dart';
import 'package:pantry_inventory/pages/product_page/product_page.dart';
import 'package:pantry_inventory/services/categories_firebase_services.dart';
import 'package:pantry_inventory/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'subproduct_page_widgets.dart';

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
  List<ProductModel> productList = [];
  PageController pageController = PageController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData(widget.category, widget.subCategory);
  }

  Future<void> fetchData(String category, String subcategory) async {
    setState(() {
      subCategoryCollection = []; // Limpiar los datos existentes
      productList = [];
      isLoading = true; // Mostrar indicador de carga
    });
    List<String> newData =
        await getSubcategoriesCollectionOnFirebase(category, subcategory);

    print(productList);
    if (newData.isNotEmpty) {
      productList = await getSubcategoriesFieldsOnFirebase(
          category, subcategory, newData[0]);
    }
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
              onPressed: () {},
              child: Image.asset(plusImage, fit: BoxFit.fitHeight),
            ),
            const SizedBox(width: 15)
          ],
        )),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            const SizedBox(height: kPaddingTop),
            TitleAppBar(
              size: size,
              title: Text(
                ('${widget.category}  ➤  ${widget.subCategory}').toUpperCase(), style: GoogleFonts.outfit(
                  fontSize: size.height * 0.025,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
              ),
            ),

            Expanded(
              child: PageView.builder(
                onPageChanged: (page) async {
                  productList = await getSubcategoriesFieldsOnFirebase(
                      widget.category,
                      widget.subCategory,
                      subCategoryCollection[page]);
                  setState(() {});
                },
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: subCategoryCollection.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return SlideInUp(
                    from: MediaQuery.of(context).size.height + 500,
                    duration: const Duration(milliseconds: 200),
                    delay: const Duration(milliseconds: 500),
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(subCategoryCollection.elementAt(index).toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 26,
                                color: kBackgroundColor,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 20),
                          Expanded(
                            child: productList.isNotEmpty
                                ? ListView.separated(
                                    itemCount: productList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        child:
                                            ProductItem(product: productList[index]),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  opaque: true,
                                                  duration: const Duration(
                                                      milliseconds: 100),
                                                  reverseDuration: const Duration(
                                                      milliseconds: 300),
                                                  type:
                                                      PageTransitionType.bottomToTop,
                                                  child: ProductPage(
                                                    category: widget.category,
                                                    subCategory: widget.subCategory,
                                                    product: productList[index],
                                                    subCategoryCollection:
                                                        subCategoryCollection
                                                            .elementAt(index),
                                                  )));
                                        },
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(height: 20);
                                    },
                                  )
                                : const NoProduct(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: 75,
      width: double.infinity,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipOval(
            child: ImageFade(
          image: NetworkImage(product.urlPhoto),
          duration: const Duration(milliseconds: 500),
          syncDuration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          fit: BoxFit.scaleDown,
          placeholder: Image.asset(placeHolderProduct, fit: BoxFit.fitWidth),
        )),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text(product.brand,
                      style: GoogleFonts.outfit(
                          fontSize: 24,
                          color: kBackgroundColor,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('\$${product.price}',
                      style: GoogleFonts.outfit(
                          fontSize: 24,
                          color: kBackgroundColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 25,
                      child: Image.asset(
                          product.stock == 0 ? iconNoStock : iconStock)),
                  const SizedBox(width: 5),
                  Text(
                    'Stock: ${product.stock}   ${product.presentation}${product.unit}',
                    style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: kBackgroundColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
