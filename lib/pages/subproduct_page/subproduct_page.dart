import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/data/data.dart';
import 'package:pantry_inventory/models/product_model.dart';
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
  bool isLoading = false;
  int pageIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    pageController = PageController(initialPage: pageIndex);

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

    if (newData.isNotEmpty) {
      productList = await getSubcategoriesFieldsOnFirebase(
          category, subcategory, newData[0]);
    }
    setState(() {
      subCategoryCollection =
          newData; // Actualizar los datos con los nuevos valores
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
        bottomNavigationBar: SubTypeBottomBar(
            pageController: pageController,
            subCategoryCollection: subCategoryCollection,
            widget: widget, index: pageIndex),
        body: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                const SizedBox(height: kPaddingTop),
                TitleAppBar(
                  size: size,
                  title: Text(
                    ('${widget.category}  ➤  ${widget.subCategory}')
                        .toUpperCase(),
                    style: GoogleFonts.outfit(
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
                    pageIndex = page;
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
                                Text(
                                    subCategoryCollection
                                        .elementAt(index)
                                        .toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 26,
                                      color: kBackgroundColor,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: productList.isNotEmpty
                                      //TODO pensar en poner un STREAM
                                      ? ListView.separated(
                                          itemCount: productList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              child: ProductItem(
                                                  product: productList[index]),
                                              onTap: () {
                                                goToProductPage(
                                                    context,
                                                    widget.category,
                                                    widget.subCategory,
                                                    productList[index],
                                                    subCategoryCollection
                                                        .elementAt(index));
                                              },
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(height: 20);
                                          },
                                        )
                                      : const NoProduct(),
                                ),
                              ],
                            )));
                  },
                ))
              ],
            )));
  }
}

class SubTypeBottomBar extends StatelessWidget {
  const SubTypeBottomBar({
    super.key,
    required this.pageController,
    required this.subCategoryCollection,
    required this.widget, required this.index
  });

  final PageController pageController;
  final List<String> subCategoryCollection;
  final SubCategoryPage widget;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Random random = Random();
              ProductModel newProduct = ProductModel(
                qtyToBuy: 0,
                brand: 'A determinar',
                price: 0.0,
                pricePerUnit: 0.0,
                presentation: "0",
                stock: 0,
                subType: subCategoryCollection[index],
                subCategory: widget.subCategory,
                category: widget.category,
                urlPhoto: "",
                unit: "gr",
                id: random.nextInt((pow(2, 32) - 1).toInt()),
              );

              goToProductPage(context, widget.category, widget.subCategory,
                  newProduct, newProduct.subType);
            },
            child: Image.asset(plusImage, fit: BoxFit.fitHeight),
          ),
          const SizedBox(width: 15)
        ],
      )),
    );
  }
}

void goToProductPage(BuildContext context, String category, String subCategory,
    ProductModel product, String subCategoryCollection) {
  Navigator.push(
      context,
      PageTransition(
          opaque: true,
          duration: const Duration(milliseconds: 100),
          reverseDuration: const Duration(milliseconds: 300),
          type: PageTransitionType.bottomToTop,
          child: ProductPage(
            category: category,
            subCategory: subCategory,
            product: product,
            subCategoryCollection: subCategoryCollection,
          )));
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
        Container(
            height: 75,
            width: 75,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: FadeInImage(
                placeholder: const AssetImage(placeHolderProduct),
                image: NetworkImage(product.urlPhoto),
                alignment: Alignment.center,
                fit: BoxFit.fill,
              ),
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
        ))
      ]),
    );
  }
}
