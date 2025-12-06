import 'package:flutter/material.dart';
import 'package:food_recipes_afame/models/authentication/otp_verify_model.dart';
import 'package:food_recipes_afame/models/authentication/resend_model.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';
import 'package:food_recipes_afame/view/Authentication/reset_password_view.dart';
import 'package:food_recipes_afame/services/local_storage_service.dart';


class OtpVerifyController extends GetxController {
  final ApiService _apiService = ApiService();

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  RxBool isLoading = false.obs;

  String getOtp() {
    return otpControllers.map((e) => e.text.trim()).join();
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<void> verifyOtp() async {
    final otp = getOtp();

    if (otp.length != 4 || int.tryParse(otp) == null) {
      Get.snackbar(
         "Invalid OTP",
         "Please enter a valid 4-digit numeric OTP",
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = {"otp": int.parse(otp)};

      final response = await _apiService.post(ApiEndpoints.verifyOtp, body);

      final result = OtpVerifyResponseModel.fromJson(response);

      // Store reset token for reset password screen
      await LocalStorageService().saveToken(result.resetPasswordToken);

      Get.snackbar(
         "Success",
         result.message,
        backgroundColor: Colors.green,
      );

      // Navigate to Reset Password View
      Get.to(() => ResetPasswordView());
    } catch (e) {
      if (e is ApiException) {
        Get.snackbar(
           "Verification Failed",
           e.message,
          backgroundColor: Colors.red,
        );
      } else {
        Get.snackbar(
           "Error",
           "Something went wrong",
          backgroundColor: Colors.red,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    isLoading.value = true;
    try {
      final body = {"purpose": "forget-password"};
      final token = await LocalStorageService().getToken();
      final response = await _apiService.post(
        ApiEndpoints.resendOtp,
        body,
        extraHeader: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      final resendresponse = OtpResendResponseModel.fromJson(response);
      if (resendresponse.success) {
        Get.snackbar(
           "Success",
           "OTP sent successfully",
          backgroundColor: Colors.green,
        );
      } else {
        Get.snackbar(
           "Failed",
           "Unknown Error Occourd",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        Get.snackbar(
           "Failed",
           e.message,
          backgroundColor: Colors.red,
        );
      } else {
        Get.snackbar(
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
