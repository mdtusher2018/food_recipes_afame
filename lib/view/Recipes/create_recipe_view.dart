import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:food_recipes_afame/controller/recipe/create_recipe.dart';
import 'package:food_recipes_afame/utils/colors.dart';
import 'package:food_recipes_afame/utils/image_paths.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';

class CreateRecipeView extends StatelessWidget {
  const CreateRecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateRecipeController>(
      init:
          CreateRecipeController()
            ..addIngredient()
            ..addInstruction(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: commonText("Create Recipe", size: 18, isBold: true),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: commonText(
                    "Cover Image",
                    fontWeight: FontWeight.w500,
                    size: 16,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: controller.pickImageFromGallery,
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: Radius.circular(16),
                      dashPattern: [5, 4],
                    ),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration:
                          (controller.imageFile == null)
                              ? null
                              : BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(controller.imageFile!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImagePaths.uploadIcon,
                            color:
                                (controller.imageFile == null)
                                    ? AppColors.black
                                    : AppColors.white,
                          ),
                          const SizedBox(height: 8),
                          commonText(
                            (controller.imageFile == null)
                                ? "Upload your image"
                                : "Change the image",
                            isBold: true,
                            color:
                                (controller.imageFile == null)
                                    ? AppColors.black
                                    : AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                commonTextfieldWithTitle(
                  "Recipe Title*",
                  controller.titleController,
                  textSize: 16.0,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: commonNumberInputField(
                        hintText: "Prep Time (mins)*",
                        value:
                            int.tryParse(controller.prepTimeController.text) ??
                            0,
                        controller: controller.prepTimeController,
                        onChanged: (_) => controller.update(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: commonNumberInputField(
                        hintText: "Cook Time (mins)*",
                        value:
                            int.tryParse(controller.cookTimeController.text) ??
                            0,
                        controller: controller.cookTimeController,
                        onChanged: (_) => controller.update(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    commonText(
                      "Difficulty Level*",
                      size: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                commonDropdown<String>(
                  value: controller.selectedDifficulty,
                  hint: "Difficulty Level*",
                  items: controller.difficulties,
                  onChanged: (val) => controller.setDifficulty(val!),
                ),
                const SizedBox(height: 12),
                commonTextfieldWithTitle(
                  "Cultural Origin",
                  controller.originController,
                  textSize: 16.0,
                ),
                const SizedBox(height: 12),
                commonTextfieldWithTitle(
                  "Description*",
                  controller.descriptionController,
                  textSize: 16.0,
                  maxLine: 4,
                ),
                const SizedBox(height: 20),

                // INGREDIENTS
                _sectionHeader("Ingredients", onAdd: controller.addIngredient),
                for (int i = 0; i < controller.ingredients.length; i++)
                  _ingredientCard(controller, i),

                const SizedBox(height: 12),

                // INSTRUCTIONS
                _sectionHeader(
                  "Instructions",
                  onAdd: controller.addInstruction,
                ),
                for (int i = 0; i < controller.instructions.length; i++)
                  _instructionCard(controller, i),

                commonTextfieldWithTitle(
                  "Cultural Background*",
                  controller.backgroundController,
                  textSize: 16.0,
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return commonButton(
                    "Create Recipe",
                    isLoading: controller.submitting.value,
                    onTap: () {
                      controller.createRecipe(
                        title: controller.titleController.text.trim(),
                        origin: controller.originController.text.trim(),
                        description:
                            controller.descriptionController.text.trim(),
                        background: controller.backgroundController.text.trim(),
                        difficulty: controller.selectedDifficulty,
                        prepTime:
                            int.tryParse(
                              controller.prepTimeController.text.trim(),
                            ) ??
                            0,
                        cookTime:
                            int.tryParse(
                              controller.cookTimeController.text.trim(),
                            ) ??
                            0,
                        ingredients:
                            controller.ingredients
                                .map(
                                  (e) => {
                                    'name': e['name']!.text,
                                    'quantity': e['quantity']!.text,
                                  },
                                )
                                .toList(),
                        instructions:
                            controller.instructions.map((e) => e.text).toList(),
                      );
                    },
                  );
                }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title, {required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        commonText(title, size: 16, fontWeight: FontWeight.w500),
        commonButton(
          "Add",
          iconWidget: Icon(Icons.add),
          width: 80,
          height: 30,
          textColor: AppColors.black,
          color: Colors.transparent,
          boarder: Border.all(width: 1),
          onTap: onAdd,
          boarderRadious: 6,
        ),
      ],
    );
  }

  Widget _ingredientCard(CreateRecipeController controller, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: commonTextfieldWithTitle(
                  "Name*",
                  controller.ingredients[index]['name']!,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: commonTextfieldWithTitle(
                  "Quantity*",
                  controller.ingredients[index]['quantity']!,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => controller.removeIngredient(index),
              icon: Icon(
                Icons.delete_outline,
                size: 24,
                color: Colors.red.shade600,
              ),
              label: commonText("Remove", size: 16, color: Colors.red.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _instructionCard(CreateRecipeController controller, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonTextfieldWithTitle(
            "Step ${index + 1}",
            controller.instructions[index],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => controller.removeInstruction(index),
              icon: Icon(
                Icons.delete_outline,
                size: 24,
                color: Colors.red.shade600,
              ),
              label: commonText("Remove", size: 16, color: Colors.red.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
