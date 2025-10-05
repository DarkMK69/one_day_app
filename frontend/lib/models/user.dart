class User {
  final int id;
  final String phone;
  final String? name;
  final String? email;
  
  User({
    required this.id,
    required this.phone,
    this.name,
    this.email,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phone: json['phone'],
      name: json['name'],
      email: json['email'],
    );
  }
}