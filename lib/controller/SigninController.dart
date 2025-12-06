import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_recipes_afame/models/authentication/login_response_model.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';
import 'package:food_recipes_afame/view/root_view.dart';

class SigninController extends GetxController {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool rememberMe = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? val) {
    rememberMe.value = val ?? false;
  }

  Future<void> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Email and Password are required",
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiService.post(ApiEndpoints.login, {
        "email": email,
        "password": password,
      });

      final loginData = LoginResponseModel.fromJson(response);
      final accessToken = loginData.data.accessToken;

      // Save token
      await _localStorageService.saveToken(accessToken);
      await _localStorageService.saveUserId(loginData.data.user.id);
      await LocalStorageService().saveName(loginData.data.user.name);
      if (rememberMe.value) {
        LocalStorageService().saveLoginToLocal(email, password);
      }

      // Navigate to root/home screen
      Get.offAll(() => RootView());
    } catch (e) {
      log(e.toString());
      if (e is ApiException) {
        Get.snackbar(
          "Login Failed",
          e.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
