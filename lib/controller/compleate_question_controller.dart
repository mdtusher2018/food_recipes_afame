import 'package:food_recipes_afame/models/authentication/compleate_profile_model.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';

class CompleteProfileController extends GetxController {
  var isLoading = false.obs;
  var profileData = Rxn<ProfileData>();

  Future<void> completeProfile({
    required String cultureHeritage,
    required String favoriteDish,
    required String pageGoal,
    required String cookingFrequency,
  }) async {
    try {
      isLoading.value = true;

      final requestBody = {
        "cultureHeritage": cultureHeritage,
        "favoriteDish": favoriteDish,
        "pageGoal": pageGoal,
        "cookingFrequency": cookingFrequency,
      };

      final response = await ApiService().patch(
        ApiEndpoints.completeProfile,
        requestBody,
      );

      final model = CompleteProfileResponseModel.fromJson(response);
      profileData.value = model.data;

      showCustomSnackbar(
        "Success",
        model.message,
        backgroundColor: const Color(0xFF4CAF50),
      );
    } catch (e) {
      showCustomSnackbar(
        "Error",
        e.toString(),
        backgroundColor: const Color(0xFFFF5252),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
