import 'package:flutter/material.dart';
import 'package:food_recipes_afame/controller/reset_password_controller.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/utils/image_paths.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: authAppBar("Reset Password"),
      backgroundColor: AppColors.primary,
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(ImagePaths.resetPageImage),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: "Now Reset Your ".tr,
                    style: TextStyle(color: AppColors.black),
                  ),
                  TextSpan(
                    text: "Password".tr,
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(
                    text: ".",
                    style: TextStyle(color: AppColors.black, fontSize: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            commonText("Password must have 6-8 characters.", size: 14.0),
            const SizedBox(height: 30),

            // New Password TextField
            commonTextfieldWithTitle(
              "New Password",
              controller.newPasswordController,
              hintText: "Enter your password",
              assetIconPath: ImagePaths.lock,
              isPasswordVisible: isPasswordVisible,
              issuffixIconVisible: true,
              changePasswordVisibility: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 15),

            // Confirm New Password TextField
            commonTextfieldWithTitle(
              "Confirm New Password",
              controller.confirmPasswordController,
              hintText: "Enter your password",
              assetIconPath: ImagePaths.lock,
              isPasswordVisible: isConfirmPasswordVisible,
              issuffixIconVisible: true,
              changePasswordVisibility: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
            ),

            const Spacer(),

            Obx(
              () =>
                  controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : commonButton(
                        "Reset Password",
                        textColor: Colors.white,
                        onTap: () {
                          controller.resetPassword();
                        },
                      ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
