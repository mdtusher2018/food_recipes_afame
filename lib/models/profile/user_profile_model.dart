import 'package:food_recipes_afame/utils/helper.dart';

class UserProfileModel {
  final bool success;
  final int statusCode;
  final String message;
  final UserData data;

  UserProfileModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final String id;
  final String name;
  final String? phone;
  final String email;
  final String role;
  final String status;
  final String image;
  final String? cookingFrequency;
  final String? cultureHeritage;
  final String? favoriteDish;
  final String? pageGoal;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.image,
    this.phone,
    this.cookingFrequency,
    this.cultureHeritage,
    this.favoriteDish,
    this.pageGoal,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
      image: getFullImagePath(json['image'] ?? ""),
      cookingFrequency: json['cookingFrequency'],
      cultureHeritage: json['cultureHeritage'],
      favoriteDish: json['favoriteDish'],
      pageGoal: json['pageGoal'],
    );
  }
}
