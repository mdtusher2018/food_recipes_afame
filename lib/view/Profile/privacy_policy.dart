import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:food_recipes_afame/controller/statics_content_controller.dart/PrivacyPolicyController.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';


class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrivacyPolicyController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        title: commonText("Privacy Policy", size: 16.0, isBold: true),
        centerTitle: true,
        leading: const BackButton(),
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.policyData.value == null) {
            return  Center(child: commonText("No privacy policy found."));
          }

          return SingleChildScrollView(
            child: Html(
              data: controller.policyData.value!.content,
              style: {
                "body": Style(fontSize: FontSize.medium),
              },
            ),
          );
        }),
      ),
    );
  }
}
