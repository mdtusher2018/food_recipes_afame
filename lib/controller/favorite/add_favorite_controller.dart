import 'package:food_recipes_afame/models/favorite/add_favorite_model.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';

class FavoriteRecipeController extends GetxController {
  var isLoading = false.obs;
  var favoriteResponse = Rxn<AddFavoriteResponseModel>();

  Future<bool> addRecipeToFavorites(String recipeId, bool isFavorite) async {
    try {
      isLoading(true);

      final response =
          isFavorite
              ? await ApiService().deleteWithBody(ApiEndpoints.removeFavorite, {
                'recipeId': recipeId,
              })
              : await ApiService().post(ApiEndpoints.addToFavorite, {
                'recipeId': recipeId,
              });

      if (response['success'] == true && response['data'] != null) {
        final model = AddFavoriteResponseModel.fromJson(response['data']);
        favoriteResponse.value = model;

        showCustomSnackbar(
          "Success",
          isFavorite
              ? "Recipe removed from favorites"
              : "Recipe added to favorites",
        );

        return true;
      } else {
        showCustomSnackbar(
          "Failed",
          isFavorite
              ? "Failed to remove from favorites"
              : "Failed to add to favorites",
        );
        return false;
      }
    } catch (e) {
      showCustomSnackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }

    return false;
  }
}
