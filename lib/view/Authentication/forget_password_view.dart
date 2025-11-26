import 'package:flutter/material.dart';
import 'package:food_recipes_afame/controller/ForgotPasswordController.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/utils/image_paths.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});

  final ForgotPasswordController controller = Get.put(
    ForgotPasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppBar("Get Verification Code"),
      backgroundColor: AppColors.primary,
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Image.asset(ImagePaths.forgetPageImage),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "Forget Your ".tr,
                    style: TextStyle(color: AppColors.black),
                  ),
                  TextSpan(
                    text: "Password".tr,
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(text: "?", style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            commonText(
              "Enter your email address to reset your password.",
              size: 14.0,
            ),
            const SizedBox(height: 30),

            // Email TextField
            commonTextfieldWithTitle(
              "Email",
              controller.emailController,
              hintText: "Enter your email",
              assetIconPath: ImagePaths.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const Spacer(),

            Obx(
              () => commonButton(
                controller.isLoading.value
                    ? "Please wait..."
                    : "Get Verification Code",
                textColor: Colors.white,
                onTap:
                    controller.isLoading.value
                        ? null
                        : controller.sendResetCode,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
