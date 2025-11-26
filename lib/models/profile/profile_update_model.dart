import 'package:food_recipes_afame/utils/helper.dart';

class ProfileUpdatedResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final ProfileData data;

  ProfileUpdatedResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ProfileUpdatedResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileUpdatedResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProfileData {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String status;
  final bool isDeleted;
  final bool isSocialLogin;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String cookingFrequency;
  final String cultureHeritage;
  final String favoriteDish;
  final String pageGoal;
  final String image;
  final String phone;

  ProfileData({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.status,
    required this.isDeleted,
    required this.isSocialLogin,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.cookingFrequency,
    required this.cultureHeritage,
    required this.favoriteDish,
    required this.pageGoal,
    required this.image,
    required this.phone,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      isSocialLogin: json['isSocialLogin'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      v: json['__v'] ?? 0,
      cookingFrequency: json['cookingFrequency'] ?? '',
      cultureHeritage: json['cultureHeritage'] ?? '',
      favoriteDish: json['favoriteDish'] ?? '',
      pageGoal: json['pageGoal'] ?? '',
      image: getFullImagePath(json['image'] ?? ''),
      phone: json['phone'] ?? '',
    );
  }
}
