import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pantry_inventory/constants.dart';
import 'package:pantry_inventory/data/data.dart';
import 'package:pantry_inventory/models/categories_model.dart';
import 'package:pantry_inventory/models/user_model.dart';
import 'package:pantry_inventory/pages/add_category/add_category.dart';
import 'package:pantry_inventory/pages/category_page/category_page.dart';
import 'package:pantry_inventory/provider/pantry_inventory_provider.dart';
import 'package:pantry_inventory/services/categories_firebase_services.dart';
import 'package:pantry_inventory/services/get_user_firebase_services.dart';
import 'package:pantry_inventory/services/register_firebase_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///Obtiene el usuario que está conectado
  final user = FirebaseAuth.instance.currentUser;

  UserModel? userFromFirebase;
  String userName = 'N/A';
  String userEmail = 'N/A';
  String urlPhoto = 'lib/assets/images/avatar.png';
  List<String> categoriesNames = [];
  List<String> urlCategoriesPhoto = [];

  @override
  initState() {
    int authUserWay = checkAuthMethod();
    if (authUserWay == 1) {
      ///Google Auth
      userName = user!.displayName!;
      userEmail = user!.email!;
      urlPhoto = user!.photoURL!;
    } else if (authUserWay == 0) {
      ///Email y Password
      fillUserName();
    }

    super.initState();
  }

  Future<void> fillUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    userFromFirebase = await readUserDataFromFirebase(user!.uid);
    userName = '${userFromFirebase!.name} ${userFromFirebase!.lastName}';
    userEmail = userFromFirebase!.email;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
                    reverseDuration: const Duration(milliseconds: 100),
                    type: PageTransitionType.rightToLeft,
                    child: const AddCategory(title: 'Agregar categoría')));
          },
          child: Image.asset(plusImage, fit: BoxFit.fitHeight),
        ),
        body: StreamBuilder<List<CategoryModel>>(
            stream: searchCategoriesOnFirebase(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final categories = snapshot.requireData;

                ///Cargar imágenes de las categorías
                return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                  child: ImageFade(
                                      height: 45,
                                      width: 45,
                                      image: NetworkImage(urlPhoto),
                                      duration:
                                          const Duration(milliseconds: 500),
                                      syncDuration:
                                          const Duration(milliseconds: 150),
                                      alignment: Alignment.center,
                                      fit: BoxFit.scaleDown,
                                      placeholder: Image.asset(
                                          avatarPlaceHolder,
                                          fit: BoxFit.fitWidth),
                                      errorBuilder: (context, error) =>
                                          Container(
                                            color: const Color(0xFF6F6D6A),
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                                avatarPlaceHolder,
                                                color: Colors.white,
                                                height: 35,
                                                fit: BoxFit.fitHeight),
                                          ))),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 20),
                                  Text(
                                    userName,
                                    style: GoogleFonts.outfit(
                                        fontSize: size.height * 0.025,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    userEmail,
                                    style: GoogleFonts.outfit(
                                        fontSize: size.height * 0.018,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    firebaseSignUserOut();
                                  })
                            ],
                          ),
                        ),
                        CategoriesFoods(
                          size: size,
                          categories: categories,
                        ),
                      ],
                    ));
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}

class CategoriesFoods extends StatelessWidget {
  const CategoriesFoods({
    super.key,
    required this.size,
    required this.categories,
  });

  final Size size;
  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      height: size.height,
      child: GridView.count(
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 3,
          children: List.generate(categories.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        opaque: true,
                        duration: const Duration(milliseconds: 300),
                        reverseDuration: const Duration(milliseconds: 100),
                        type: PageTransitionType.bottomToTop,
                        child: CategoryPage(
                            categories: categories, index: index)));
              },
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: size.width * 0.25,
                  child: Column(
                    children: [
                      Text(
                        categories[index].nameCategory.toUpperCase(),
                        style: GoogleFonts.outfit(
                            fontSize: size.height * 0.018,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      ImageFade(
                          height: 80,
                          width: 80,
                          image:
                              NetworkImage(categories[index].urlCategoryImage),
                          duration: const Duration(milliseconds: 500),
                          syncDuration: const Duration(milliseconds: 500),
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          placeholder: Container(
                              margin: const EdgeInsets.all(10),
                              child: Image.asset(
                                placeHolderCategory,
                                fit: BoxFit.scaleDown,
                                color: Colors.white,
                              )))
                    ],
                  )),
            );
          })),
    );
  }
}
