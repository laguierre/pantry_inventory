import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/models/product_model.dart';
import 'package:pantry_inventory/pages/login_page/login_page.dart';
import 'package:pantry_inventory/widgets.dart';

class ProductPage extends StatelessWidget {
  const ProductPage(
      {super.key,
      required this.category,
      required this.subCategory,
      required this.product,
      required this.subCategoryCollection});

  final String category;
  final String subCategory;
  final String subCategoryCollection;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBody: true,
      body: Column(
        children: [
          const SizedBox(height: kPaddingTop),
          TitleAppBar(
            size: size,
            title: Text(('$category  ➤  $subCategory').toUpperCase(),
                style: GoogleFonts.outfit(
                    fontSize: size.height * 0.025,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
          Expanded(
              child: SlideInUp(
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Marca: ',
                                style: GoogleFonts.outfit(
                                    fontSize: size.height * 0.035,
                                    fontWeight: FontWeight.normal,
                                    color: kBackgroundColor)),
                            TextSpan(
                                text: product.brand,
                                style: GoogleFonts.outfit(
                                    fontSize: size.height * 0.035,
                                    fontWeight: FontWeight.bold,
                                    color: kBackgroundColor)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Precio: \$',
                                style: GoogleFonts.outfit(
                                    fontSize: size.width * 0.06,
                                    fontWeight: FontWeight.normal,
                                    color: kBackgroundColor)),
                            TextSpan(
                                text: product.price.toString(),
                                style: GoogleFonts.outfit(
                                    fontSize: size.width * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: kBackgroundColor)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Precio por unidad: \$',
                                style: GoogleFonts.outfit(
                                    fontSize: size.width * 0.06,
                                    fontWeight: FontWeight.normal,
                                    color: kBackgroundColor)),
                            TextSpan(
                                text: product.pricePerUnit.toString(),
                                style: GoogleFonts.outfit(
                                    fontSize: size.width * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: kBackgroundColor)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Presentación: ',
                                style: GoogleFonts.outfit(
                                    fontSize: size.width * 0.06,
                                    fontWeight: FontWeight.normal,
                                    color: kBackgroundColor)),
                            TextSpan(
                                text: '${product.presentation} ${product.unit}',
                                style: GoogleFonts.outfit(
                                    fontSize: size.width * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: kBackgroundColor)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          height: size.height * 0.3,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.black, // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                          child: ImageFade(
                              image: NetworkImage(product.urlPhoto),
                              duration: const Duration(milliseconds: 500),
                              syncDuration: const Duration(milliseconds: 500),
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              placeholder: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    placeHolderCategory,
                                    fit: BoxFit.scaleDown,
                                    color: kBackgroundColor,
                                  ))),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                              height: 35,
                              child: Image.asset(product.stock == 0
                                  ? iconNoStock
                                  : iconStock)),
                          const SizedBox(width: 5),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Stock: ',
                                    style: GoogleFonts.outfit(
                                        fontSize: size.width * 0.06,
                                        fontWeight: FontWeight.normal,
                                        color: kBackgroundColor)),
                                TextSpan(
                                    text: '${product.stock.toString()}',
                                    style: GoogleFonts.outfit(
                                        fontSize: size.width * 0.06,
                                        fontWeight: FontWeight.bold,
                                        color: kBackgroundColor)),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: kBackgroundColor,
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                              height: 35, child: Image.asset(iconAddToCart)),
                          const SizedBox(width: 10),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Comprar: ',
                                    style: GoogleFonts.outfit(
                                        fontSize: size.width * 0.06,
                                        fontWeight: FontWeight.normal,
                                        color: kBackgroundColor)),
                                TextSpan(
                                    text: product.qtyToBuy.toString(),
                                    style: GoogleFonts.outfit(
                                        fontSize: size.width * 0.06,
                                        fontWeight: FontWeight.bold,
                                        color: kBackgroundColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: WideButton(
                            backgroundColor: Colors.red,
                            titleColor: Colors.white,
                            title: 'Actualizar',
                            onPressed: () {}),
                      )
                    ]),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
