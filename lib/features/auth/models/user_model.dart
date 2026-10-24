class UserModel {
  String name;
  String email;
 

  UserModel({required this.name, required this.email,});

  //to json
  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, };
  }

  //from json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      
    );
  }
}
