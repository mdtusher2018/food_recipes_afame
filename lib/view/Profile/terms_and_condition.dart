import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:food_recipes_afame/controller/statics_content_controller.dart/trems_and_policy_controller.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';

class TermsAndConditonScreen extends StatelessWidget {
  const TermsAndConditonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TremsAndConditionController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: commonText("Terms & Policies", size: 18, isBold: true),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.policyData.value == null) {
            return Center(child: commonText("No Terms & Policies found."));
          }

          return SingleChildScrollView(
            child: Html(
              data: controller.policyData.value!.content,
              style: {"body": Style(fontSize: FontSize.medium)},
            ),
          );
        }),
      ),
    );
  }
}
