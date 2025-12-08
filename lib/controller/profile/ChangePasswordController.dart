import 'package:flutter/material.dart';
import 'package:food_recipes_afame/models/profile/change_password_model.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;

  var isOldPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  Future<void> changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      showCustomSnackbar("Error", "All fields are required");
      return;
    }

    if (newPassword != confirmPassword) {
      showCustomSnackbar("Error", "New passwords do not match");
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService().post(ApiEndpoints.changePassword, {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      });

      final result = ChangePasswordResponseModel.fromJson(response);

      if (result.success) {
        Get.back();
        showCustomSnackbar(
          "Success",
          result.message,
          backgroundColor: Colors.green,
        );
      } else {
        throw result.message;
      }
    } catch (e) {
      showCustomSnackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
