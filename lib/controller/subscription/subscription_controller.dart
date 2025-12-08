import 'package:food_recipes_afame/models/subscription/subscriptionModel.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';

import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';

class SubscriptionController extends GetxController {
  var isLoading = false.obs;
  var subscriptions = <SubscriptionPlan>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptions();
  }

  Future<void> fetchSubscriptions() async {
    try {
      isLoading(true);
      final response = await ApiService().get(
        ApiEndpoints.getSubscriptions,
      ); // Make sure this matches your endpoint
      final data = SubscriptionResponse.fromJson(response);
      subscriptions.assignAll(data.data.result);
    } catch (e) {
      showCustomSnackbar('Error', 'Failed to load subscriptions');
    } finally {
      isLoading(false);
    }
  }
}
