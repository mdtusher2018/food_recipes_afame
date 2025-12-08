import 'package:flutter/material.dart';
import 'package:food_recipes_afame/models/authentication/email_verify_response_model.dart';
import 'package:food_recipes_afame/models/authentication/resend_model.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/services/local_storage_service.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';
import 'package:food_recipes_afame/view/Authentication/compleate_question_view.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';

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
      showCustomSnackbar(
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
        showCustomSnackbar(
          "Success",
          verifyResponse.message,
          backgroundColor: Colors.green,
        );
        await LocalStorageService().saveToken(verifyResponse.token);
        await LocalStorageService().saveName(verifyResponse.data.name);
        Get.to(() => CompleateQuestionnaireFlow(fromSignup: true));
      } else {
        showCustomSnackbar(
          "Failed",
          verifyResponse.message,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        showCustomSnackbar(
          "Verification Failed",
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
        showCustomSnackbar(
          "Success",
          "OTP sent successfully",
          backgroundColor: Colors.green,
        );
      } else {
        showCustomSnackbar(
          "Failed",
          "Unknown Error Occourd",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        showCustomSnackbar("Failed", e.message, backgroundColor: Colors.red);
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
