/// Model untuk maklumat asas pengguna selepas log masuk.
class UserModel {
  final String fullName;
  final String? homePage;
  final String? message;

  UserModel({
    required this.fullName,
    this.homePage,
    this.message,
  });

  /// Menukar JSON dari API kepada objek UserModel.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['full_name'] ?? 'Pengguna',
      homePage: json['home_page'],
      message: json['message'],
    );
  }

  /// Menukar objek UserModel kepada JSON (berguna untuk simpan dalam Local Storage).
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'home_page': homePage,
      'message': message,
    };
  }

  /// Membolehkan kita mengemaskini data tanpa mencipta objek baru secara manual.
  UserModel copyWith({
    String? fullName,
    String? homePage,
    String? message,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      homePage: homePage ?? this.homePage,
      message: message ?? this.message,
    );
  }
}
