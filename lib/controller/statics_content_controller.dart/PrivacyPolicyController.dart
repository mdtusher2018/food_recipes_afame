import 'dart:developer';

import 'package:food_recipes_afame/models/static_model/privacy_policy_model.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/services/api_service.dart';

class PrivacyPolicyController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<StaticContentModel> policyData = Rxn<StaticContentModel>();

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      final response = await ApiService().get(
        'static_content?type=privacy-policy',
      );

      if (response['success'] == true) {
        policyData.value = StaticContentModel.fromJson(response['data']);
      }
    } catch (e) {
      log(e.toString());
      showCustomSnackbar('Error', 'Failed to load privacy policy');
    } finally {
      isLoading.value = false;
    }
  }
}
