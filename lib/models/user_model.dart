class UserModel {
  String email;
  String name;
  String lastName;
  int age;

  UserModel(
      {required this.email,
      required this.name,
      required this.lastName,
      this.age = 0,
      });
}
