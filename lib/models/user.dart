class User {
  late String name, email, mobile;
  User({required this.name, required this.email, required this.mobile});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["email"] = email;
    user["name"] = name;

    user["mobile"] = mobile;
    return user;
  }

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        mobile = json["mobile"];
}
