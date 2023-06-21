class CategoryModel {
  String nameCategory;
  String urlCategoryImage;
  //@TODO agregar cantidad de subcomponentes

  CategoryModel({
    required this.nameCategory,
    required this.urlCategoryImage,
  });

  Map<String, dynamic> toJson() => {
    'name': nameCategory,
    'url': urlCategoryImage,
  };

  static CategoryModel fromJson(Map<String, dynamic> json) => CategoryModel(
    nameCategory: json['name'],
    urlCategoryImage: json['url'],
  );
}
