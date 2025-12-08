import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';
import 'package:food_recipes_afame/models/profile/my_recipe_model.dart';
import 'package:food_recipes_afame/services/api_service.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';

class MyRecipesController extends GetxController {
  var recipes = <MyRecipe>[].obs;
  var isLoading = false.obs;
  var meta = Rxn<MetaData>(); // optional: if you want pagination info

  @override
  void onInit() {
    super.onInit();
    fetchMyRecipes();
  }

  Future<void> fetchMyRecipes() async {
    try {
      isLoading(true);

      final response = await ApiService().get(ApiEndpoints.myRecipes);
      final myRecipeResponse = MyRecipesResponse.fromJson(response);

      recipes.assignAll(myRecipeResponse.data.result);
      meta.value = myRecipeResponse.data.meta;
    } catch (e) {
      showCustomSnackbar("Error", "Failed to load recipes");
      print("Error fetching recipes: $e");
    } finally {
      isLoading(false);
    }
  }
}
