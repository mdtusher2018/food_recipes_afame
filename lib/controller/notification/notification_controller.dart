import 'package:food_recipes_afame/models/notification/notification_model.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';

class NotificationController extends GetxController {
  var notifications = <AppNotification>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      final response = await ApiService().get(ApiEndpoints.notifications);
      final model = NotificationModel.fromJson(response);
      notifications.assignAll(model.data.result);
    } catch (e) {
      showCustomSnackbar("Error", "Failed to load notifications");
    } finally {
      isLoading(false);
    }
  }
}
