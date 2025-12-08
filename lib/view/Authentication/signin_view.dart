import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_recipes_afame/controller/SigninController.dart';
import 'package:food_recipes_afame/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/view/Authentication/signup_view.dart';
import 'package:food_recipes_afame/view/Authentication/forget_password_view.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/utils/image_paths.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';

class SigninView extends StatefulWidget {
  SigninView({Key? key}) : super(key: key);

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final SigninController controller = Get.put(SigninController());

  final emailController = TextEditingController(
    text: kDebugMode ? "amina.rahman@example.com" : null,
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? "hello12345" : null,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSavedAccountsBottomSheet(context);
    });
  }

  void showSavedAccountsBottomSheet(BuildContext context) async {
    final savedLogins = await LocalStorageService().getSavedLogins();
    if (savedLogins.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person, color: AppColors.primary),
                      const SizedBox(width: 8),
                      commonText("Select an account", size: 16, isBold: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...savedLogins.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.account_circle_rounded,
                          color: AppColors.primary,
                          size: 30,
                        ),
                        title: commonText(entry.key, size: 14, isBold: true),
                        subtitle: commonText("••••••••"),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () async {
                            await LocalStorageService().removeLogin(entry.key);
                            Navigator.pop(context);
                            showSavedAccountsBottomSheet(context); // refresh
                          },
                        ),
                        onTap: () {
                          controller.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: commonText(
          "Sign In to Your Account",
          size: 20,
          isBold: true,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      bottomSheet: SizedBox(
        height: double.infinity,
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                commonTextfieldWithTitle(
                  'Email',
                  emailController,
                  assetIconPath: ImagePaths.email,
                  hintText: "Enter your email",
                  enable: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                commonTextfieldWithTitle(
                  'Password',
                  passwordController,
                  assetIconPath: ImagePaths.lock,
                  hintText: "Enter your password",
                  enable: true,
                  isPasswordVisible: !controller.isPasswordVisible.value,
                  issuffixIconVisible: true,
                  changePasswordVisibility: controller.togglePasswordVisibility,
                ),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.rememberMe.value,
                        onChanged: controller.toggleRememberMe,
                        activeColor: AppColors.gray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(color: AppColors.gray),
                      ),
                    ),
                    commonText("Remember me"),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        navigateToPage(ForgotPasswordView());
                      },
                      child: commonText("Forgot Password", isBold: true),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                commonButton(
                  "Sign In",
                  onTap: () {
                    controller.login(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      commonText(
                        "Don’t have an account?   ",
                        size: 14,
                        color: Colors.black87,
                      ),
                      GestureDetector(
                        onTap: () {
                          navigateToPage(SignUpView());
                        },
                        child: commonText("Sign Up", size: 14, isBold: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
