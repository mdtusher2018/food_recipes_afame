import 'package:flutter/material.dart';
import 'package:food_recipes_afame/controller/signupController.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/utils/image_paths.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:food_recipes_afame/view/Authentication/signin_view.dart';

class SignUpView extends StatelessWidget {
  SignUpView({Key? key}) : super(key: key);

  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        backgroundColor: AppColors.primary,
        appBar: authAppBar("Create Account"),
        bottomSheet: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonTextfieldWithTitle(
                  'Full name',
                  controller.fullNameController,
                  assetIconPath: ImagePaths.profile,
                  hintText: "Enter your full name",
                  borderWidth: 0.0,
                  enable: true,
                ),
                const SizedBox(height: 16),
                commonTextfieldWithTitle(
                  'Email',
                  controller.emailController,
                  assetIconPath: ImagePaths.email,
                  hintText: "Enter your email",
                  enable: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                commonTextfieldWithTitle(
                  'Password',
                  controller.passwordController,
                  assetIconPath: ImagePaths.lock,
                  hintText: "Enter your password",
                  enable: true,
                  isPasswordVisible: !controller.isPasswordVisible.value,
                  issuffixIconVisible: true,
                  changePasswordVisibility: controller.togglePasswordVisibility,
                ),
                const SizedBox(height: 16),
                commonTextfieldWithTitle(
                  'Confirm Password',
                  controller.confirmPassController,
                  assetIconPath: ImagePaths.lock,
                  hintText: "Enter your password",
                  enable: true,
                  isPasswordVisible: !controller.isConfirmPassVisible.value,
                  issuffixIconVisible: true,
                  changePasswordVisibility:
                      controller.toggleConfirmPassVisibility,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: controller.isTermsAccepted.value,
                      onChanged: controller.toggleTermsAccepted,
                      activeColor: AppColors.gray,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(color: Colors.black26),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "Agree with ".tr,
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Terms and Conditions".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                commonButton("Sign Up", height: 50, onTap: controller.signup),
                const SizedBox(height: 32),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      commonText(
                        "Already have an account? ",
                        size: 14,
                        color: Colors.black87,
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateToPage(SigninView());
                        },
                        child: commonText("Sign In", size: 14, isBold: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
