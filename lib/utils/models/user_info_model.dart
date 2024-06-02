class UserInfoModel {
  String name;
  String field;
  String grade;

  UserInfoModel({
    required this.name,
    required this.field,
    required this.grade,
  });

  UserInfoModel copyWith({
    String? name,
    String? field,
    String? grade,
  }) {
    return UserInfoModel(
      name: name ?? this.name,
      field: field ?? this.field,
      grade: grade ?? this.grade,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'field': field,
      'grade': grade,
    };
  }

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      name: json['name'] as String,
      field: json['field'] as String,
      grade: json['grade'] as String,
    );
  }

  @override
  String toString() => "UserInfoModel(name: $name,field: $field,grade: $grade)";

  @override
  int get hashCode => Object.hash(name, field, grade);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          field == other.field &&
          grade == other.grade;
}
