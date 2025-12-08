import 'package:flutter/material.dart';
import 'package:food_recipes_afame/models/authentication/signup_response_model.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/services/local_storage_service.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';
import 'package:food_recipes_afame/view/Authentication/email_verify_view.dart';

class SignupController extends GetxController {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPassVisible = false.obs;
  RxBool isTermsAccepted = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPassVisibility() {
    isConfirmPassVisible.value = !isConfirmPassVisible.value;
  }

  void toggleTermsAccepted(bool? val) {
    isTermsAccepted.value = val ?? false;
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> signup() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPassController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showCustomSnackbar(
        "Validation Error",
        "All fields are required",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (fullName.length < 3) {
      showCustomSnackbar(
        "Validation Error",
        "Full name must be at least 3 characters",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (!_isValidEmail(email)) {
      showCustomSnackbar(
        "Validation Error",
        "Invalid email format",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (password.length < 8) {
      showCustomSnackbar(
        "Validation Error",
        "Password must be at least 8 characters",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (password != confirmPassword) {
      showCustomSnackbar(
        "Validation Error",
        "Passwords do not match",
        backgroundColor: Colors.red,
      );
      return;
    }

    if (!isTermsAccepted.value) {
      showCustomSnackbar(
        "Terms Not Accepted",
        "You must agree with Terms and Conditions",
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        "name": fullName,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
      };

      final response = await _apiService.post(ApiEndpoints.register, body);

      final signupResponse = SignupResponseModel.fromJson(response);
      await _localStorageService.saveToken(signupResponse.data.signUpToken);

      // Navigate to Email Verify page with token if needed
      Get.to(() => EmailVerifyView());
    } catch (e) {
      if (e is ApiException) {
        showCustomSnackbar(
          "Signup Failed",
          e.message,
          backgroundColor: Colors.red,
        );
      } else {
        showCustomSnackbar(
          "Error",
          "Something went wrong",
          backgroundColor: Colors.red,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
