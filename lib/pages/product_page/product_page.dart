import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/models/product_model.dart';
import 'package:pantry_inventory/pages/login_page/login_page.dart';
import 'package:pantry_inventory/provider/product_provider.dart';
import 'package:pantry_inventory/widgets.dart';
import 'package:provider/provider.dart';
import 'product_page_widgets.dart';

class ProductPage extends StatefulWidget {
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
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String inputText = "";
  TextEditingController textEditingController = TextEditingController();
  bool isChangePhoto = false;
  final ImagePicker imagePicker = ImagePicker();
  XFile? photo;
  dynamic imageSource;

  @override
  void initState() {
    super.initState();
    final product = Provider.of<ProductProvider>(context, listen: false);

    ///Copiar el producto en el provider
    product.setProductInfo(widget.product, widget.category, widget.subCategory,
        widget.subCategoryCollection);
    if (product.urlPhoto == "") {
      imageSource = const AssetImage(placeHolderCategory);
    } else {
      imageSource = NetworkImage(
        product.urlPhoto,
      );
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kBackgroundColor,
        extendBody: true,
        body: Consumer<ProductProvider>(
          builder: (context, product, _) {
            return Column(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      InfoLineAndEdit(
                                        noBoldText: 'Marca: ',
                                        boldText: product.brand,
                                        sizeText: size.height * 0.035,
                                        onPressed: () async {
                                          textEditingController.text =
                                              product.brand;
                                          product.brand = await openPopup(
                                              product.brand,
                                              TextInputType.text,
                                              context,
                                              textEditingController);
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      InfoLineAndEdit(
                                        noBoldText: 'Precio: \$',
                                        boldText: product.price.toString(),
                                        sizeText: size.width * 0.06,
                                        onPressed: () async {
                                          textEditingController.text =
                                              product.price.toString();
                                          product.price = double.parse(
                                              await openPopup(
                                                  product.price.toString(),
                                                  TextInputType.number,
                                                  context,
                                                  textEditingController));
                                        },
                                      ),
                                      const SizedBox(height: 5),
                                      InfoLineAndEdit(
                                        noBoldText: 'Precio por unidad: \$',
                                        boldText:
                                            product.pricePerUnit.toString(),
                                        sizeText: size.width * 0.06,
                                        onPressed: () async {
                                          textEditingController.text =
                                              product.pricePerUnit.toString();
                                          product.pricePerUnit = double.parse(
                                              await openPopup(
                                                  product.pricePerUnit
                                                      .toString(),
                                                  TextInputType.number,
                                                  context,
                                                  textEditingController));
                                        },
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          InfoLineAndEdit(
                                            noBoldText: 'Presentación: ',
                                            boldText: product.presentation,
                                            sizeText: size.width * 0.06,
                                            onPressed: () async {
                                              textEditingController.text =
                                                  product.presentation;
                                              product.presentation =
                                                  await openPopup(
                                                      product.presentation,
                                                      TextInputType.text,
                                                      context,
                                                      textEditingController);
                                            },
                                          ),
                                          InfoLineAndEdit(
                                            noBoldText: ' ',
                                            boldText: product.unit,
                                            sizeText: size.width * 0.06,
                                            onPressed: () async {
                                              textEditingController.text =
                                                  product.unit;
                                              product.unit = await openPopup(
                                                  product.unit,
                                                  TextInputType.text,
                                                  context,
                                                  textEditingController);
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          height: size.height * 0.3,
                                          width: size.width * 0.8,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                              color: Colors.black,
                                              // Border color
                                              width: 1.0, // Border width
                                            ),
                                            image: _buildDecorationImage(
                                                imageSource),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width: size.width * 0.8,
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(
                                                  color: kBackgroundColor,
                                                  size: 60,
                                                  Icons.camera_alt_rounded),
                                              onPressed: () async {
                                                XFile? bufferPhoto =
                                                    await imagePicker.pickImage(
                                                        source:
                                                            ImageSource.camera);
                                                if (bufferPhoto != null) {
                                                  imageSource =
                                                      photo = bufferPhoto;
                                                  isChangePhoto = true;
                                                }
                                                setState(() {});
                                              },
                                            ),
                                            const SizedBox(width: 20),
                                            IconButton(
                                                onPressed: () async {
                                                  XFile? bufferPhoto =
                                                      await imagePicker
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  if (bufferPhoto != null) {
                                                    imageSource =
                                                        photo = bufferPhoto;
                                                    isChangePhoto = true;
                                                  }
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                    color: kBackgroundColor,
                                                    size: 60,
                                                    Icons
                                                        .drive_folder_upload_rounded)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          SizedBox(
                                              height: 35,
                                              child: Image.asset(
                                                  product.stock == 0
                                                      ? iconNoStock
                                                      : iconStock)),
                                          const SizedBox(width: 5),
                                          InfoLineAndEdit(
                                            noBoldText: 'Stock: ',
                                            boldText: product.stock.toString(),
                                            sizeText: size.width * 0.06,
                                            onPressed: () async {
                                              textEditingController.text =
                                                  product.stock.toString();
                                              product.stock = int.parse(
                                                  await openPopup(
                                                      product.stock.toString(),
                                                      TextInputType.text,
                                                      context,
                                                      textEditingController));
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          SizedBox(
                                              height: 35,
                                              child:
                                                  Image.asset(iconAddToCart)),
                                          const SizedBox(width: 10),
                                          InfoLineAndEdit(
                                            noBoldText: 'Comprar: ',
                                            boldText:
                                                product.qtyToBuy.toString(),
                                            sizeText: size.width * 0.06,
                                            onPressed: () async {
                                              textEditingController.text =
                                                  product.qtyToBuy.toString();
                                              product.qtyToBuy = int.parse(
                                                  await openPopup(
                                                      product.qtyToBuy
                                                          .toString(),
                                                      TextInputType.number,
                                                      context,
                                                      textEditingController));
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        margin: const EdgeInsets.all(20),
                                        child: WideButton(
                                            backgroundColor: Colors.red,
                                            titleColor: Colors.white,
                                            title: 'Guardar',
                                            onPressed: () {
                                              saveProductOnFireBase(
                                                  product, photo);
                                              //Navigator.pop(context);
                                            }),
                                      )
                                    ]))))),
              ],
            );
          },
        ));
  }

  DecorationImage _buildDecorationImage(dynamic imageSource) {
    if (imageSource is NetworkImage) {
      return DecorationImage(
        image: imageSource,
        fit: BoxFit.cover,
      );
    } else if (imageSource is AssetImage) {
      return DecorationImage(
        image: imageSource,
        fit: BoxFit.scaleDown,
      );
    } else if (imageSource is XFile) {
      return DecorationImage(
        image: FileImage(File(imageSource.path)),
        fit: BoxFit.cover,
      );
    } else {
      throw ArgumentError('Invalid image source');
    }
  }
}

Future saveProductOnFireBase(ProductProvider product, XFile? photo) async {
  final productFirebase = FirebaseFirestore.instance
      .collection(subcategoryCollection)
      .doc(product.category)
      .collection(product.subCategory)
      .doc(product.subType)
      .collection(product.subType)
      .doc(product.id.toString());

  ///Guarda la imagen en Firebase y obtiene el URL, siempre que no sea NULL
  ///o esté vacío la imagen
  if (photo != null || product.urlPhoto == "") {
    UploadTask? uploadTask;
    String folder = 'products';
    final path = '$folder/${product.id}';
    final file = File(photo!.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    product.urlPhoto = urlDownload;
    debugPrint('Download Link: $urlDownload');
  }
  //----------------------------------------
  //TODO ver porqué pone en subType erronamente

  final productToSave = ProductModel(
      id: product.id,
      qtyToBuy: product.qtyToBuy,
      brand: product.brand,
      price: product.price,
      pricePerUnit: product.pricePerUnit,
      presentation: product.presentation,
      stock: product.stock,
      subType: product.subType,
      subCategory: product.subCategory,
      category: product.category,
      urlPhoto: product.urlPhoto,
      unit: product.unit);

  final json = productToSave.toJson();
  print(json);
  await productFirebase.set(json);
}
