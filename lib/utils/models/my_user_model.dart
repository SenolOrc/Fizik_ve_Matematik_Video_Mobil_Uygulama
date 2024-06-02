class MyUser {
  String id;
  String name;
  String email;

  MyUser({
    required this.id,
    required this.name,
    required this.email,
  });

  MyUser copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return MyUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  static final empty = MyUser(id: '', name: '', email: '');

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => "MyUser(id: $id,name: $name,email: $email)";

  @override
  int get hashCode => Object.hash(id, name, email);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyUser &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email;
}
