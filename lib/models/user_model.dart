class UserModel {
  String email;
  String name;
  String lastName;
  String userToken;
  int age;

  UserModel({
    required this.email,
    required this.name,
    required this.lastName,
    required this.userToken,
    this.age = 0,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'lastname': lastName,
        'age': age,
        'userToken': userToken,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email'],
        name: json['name'],
        lastName: json['lastname'],
        age: json['age'],
        userToken: json['userToken'],
      );
}
