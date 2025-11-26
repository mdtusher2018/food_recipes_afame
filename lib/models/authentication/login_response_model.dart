import 'package:food_recipes_afame/utils/helper.dart';

class LoginResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final LoginData data;

  LoginResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? "",
      message: json['message'] ?? "",
      data: LoginData.fromJson(json['data']),
    );
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['accessToken'] ?? "",
      refreshToken: json['refreshToken'] ?? "",
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final bool isDeleted;
  final bool isSocialLogin;
  final bool isCompleted;
  final String createdAt;
  final String updatedAt;
  final String cookingFrequency;
  final String cultureHeritage;
  final String favoriteDish;
  final String pageGoal;
  final String image;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.isDeleted,
    required this.isSocialLogin,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.cookingFrequency,
    required this.cultureHeritage,
    required this.favoriteDish,
    required this.pageGoal,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      role: json['role'] ?? "",
      status: json['status'] ?? "",
      isDeleted: json['isDeleted'] ?? false,
      isSocialLogin: json['isSocialLogin'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      cookingFrequency: json['cookingFrequency'] ?? "",
      cultureHeritage: json['cultureHeritage'] ?? "",
      favoriteDish: json['favoriteDish'] ?? "",
      pageGoal: json['pageGoal'] ?? "",
      image: getFullImagePath(json['image'] ?? ""),
    );
  }
}
