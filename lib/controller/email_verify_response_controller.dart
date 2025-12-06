import 'package:flutter/material.dart';
import 'package:food_recipes_afame/models/authentication/email_verify_response_model.dart';
import 'package:food_recipes_afame/models/authentication/resend_model.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/services/local_storage_service.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';
import 'package:food_recipes_afame/view/Authentication/compleate_question_view.dart';

import 'package:get/get.dart';

class EmailVerifyController extends GetxController {
  final ApiService _apiService = ApiService();

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  EmailVerifyController(); // <-- Accept signUpToken

  RxBool isLoading = false.obs;

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  String getOtp() => otpControllers.map((e) => e.text).join();

  Future<void> verifyEmail() async {
    final otp = getOtp();

    if (otp.length != 4) {
      Get.snackbar(
         "Invalid OTP",
         "Please enter a valid 4-digit OTP",
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = {"otp": int.parse(otp)};

      String token = await LocalStorageService().getToken() ?? "";
      final response = await _apiService.post(
        ApiEndpoints.verifyEmail,
        body,
        extraHeader: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final verifyResponse = EmailVerifyResponseModel.fromJson(response);

      if (verifyResponse.success) {
        Get.snackbar(
           "Success",
           verifyResponse.message,
          backgroundColor: Colors.green,
        );
        await LocalStorageService().saveToken(verifyResponse.token);
        await LocalStorageService().saveName(verifyResponse.data.name);
        Get.to(() => CompleateQuestionnaireFlow(fromSignup: true));
      } else {
        Get.snackbar(
           "Failed",
           verifyResponse.message,
          backgroundColor: Colors.red,
        );
      }
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
      final body = {"purpose": "email-verification"};
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
