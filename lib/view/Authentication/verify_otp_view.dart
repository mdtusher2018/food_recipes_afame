import 'package:flutter/material.dart';
import 'package:food_recipes_afame/controller/otp_verify_controller.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/utils/image_paths.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';

class OtpVerifyView extends StatelessWidget {
  OtpVerifyView({super.key});

  final OtpVerifyController controller = Get.put(OtpVerifyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppBar("Verify Email"),
      backgroundColor: AppColors.primary,
      bottomSheet: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Image.asset(ImagePaths.verificationPageImage),
              const SizedBox(height: 10),
              RichText(
                text:  TextSpan(
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "Enter ".tr,
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "Verification".tr,
                      style: TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(
                      text: " Code.".tr,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              commonText(
                "Enter the code that was sent to your email.",
                size: 14.0,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: buildOTPTextField(
                      controller.otpControllers[index],
                      index,
                      context,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonText(
                    "Didn't receive the code? ",
                    size: 14.0,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.resendOtp();
                    },
                    child: commonText(
                      "Resend",
                      size: 14.0,
                      color: Colors.black,
                      isBold: true,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : commonButton(
                    "Verify",
                    textColor: Colors.white,
                    onTap: controller.verifyOtp,
                  ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
