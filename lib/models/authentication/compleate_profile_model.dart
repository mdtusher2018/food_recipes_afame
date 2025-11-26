import 'package:food_recipes_afame/utils/helper.dart';

class CompleteProfileResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final ProfileData data;

  CompleteProfileResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CompleteProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return CompleteProfileResponseModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: ProfileData.fromJson(json['data']),
    );
  }
}

class ProfileData {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isCompleted;
  final String cultureHeritage;
  final String favoriteDish;
  final String pageGoal;
  final String cookingFrequency;
  final String image;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isCompleted,
    required this.cultureHeritage,
    required this.favoriteDish,
    required this.pageGoal,
    required this.cookingFrequency,
    required this.image,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      isCompleted: json['isCompleted'],
      cultureHeritage: json['cultureHeritage'],
      favoriteDish: json['favoriteDish'],
      pageGoal: json['pageGoal'],
      cookingFrequency: json['cookingFrequency'],
      image: getFullImagePath(json['image'] ?? ''),
    );
  }
}
