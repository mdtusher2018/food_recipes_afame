import 'dart:developer';

import 'package:food_recipes_afame/models/static_model/privacy_policy_model.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/services/api_service.dart';

class TremsAndConditionController extends GetxController {
  RxBool isLoading = false.obs;
  Rxn<StaticContentModel> policyData = Rxn<StaticContentModel>();

  @override
  void onInit() {
    super.onInit();
    fetchTremsAndPolicy();
  }

  Future<void> fetchTremsAndPolicy() async {
    try {
      isLoading.value = true;
      final response = await ApiService().get(
        'static_content?type=terms-and-policy',
      );

      if (response['success'] == true) {
        if (response['data'] != null) {
          policyData.value = StaticContentModel.fromJson(response['data']);
        }
      }
    } catch (e) {
      log(e.toString());
      showCustomSnackbar('Error', 'Failed to load privacy policy');
    } finally {
      isLoading.value = false;
    }
  }
}
