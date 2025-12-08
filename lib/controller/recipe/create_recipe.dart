import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';
import 'package:food_recipes_afame/view/shared/commonWidgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:food_recipes_afame/services/local_storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class CreateRecipeController extends GetxController {
  File? imageFile;
  File? musicFile;

  final titleController = TextEditingController();
  final originController = TextEditingController();
  final descriptionController = TextEditingController();
  final backgroundController = TextEditingController();
  final prepTimeController = TextEditingController();
  final cookTimeController = TextEditingController();

  String selectedDifficulty = 'Medium';
  final difficulties = ['Easy', 'Medium', 'Hard'];

  List<Map<String, TextEditingController>> ingredients = [];
  List<TextEditingController> instructions = [];

  void addIngredient() {
    ingredients.add({
      'name': TextEditingController(),
      'quantity': TextEditingController(),
    });
    update();
  }

  void removeIngredient(int index) {
    ingredients.removeAt(index);
    update();
  }

  void addInstruction() {
    instructions.add(TextEditingController());
    update();
  }

  void removeInstruction(int index) {
    instructions.removeAt(index);
    update();
  }

  void setDifficulty(String value) {
    selectedDifficulty = value;
    update();
  }

  void setImage(File file) {
    imageFile = file;
    update();
  }

  void setMusic(File file) {
    musicFile = file;
    update();
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setImage(File(pickedFile.path));
    } else {
      showCustomSnackbar("No image", "Image picking was cancelled");
    }
  }

  /// Pick music (mp3) from device
  Future<void> pickMusicFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    if (result != null && result.files.single.path != null) {
      setMusic(File(result.files.single.path!));
    } else {
      showCustomSnackbar("No file", "Music file selection was cancelled");
    }
  }

  RxBool submitting = false.obs;

  /// Submit recipe to API
  Future<void> createRecipe({
    required String title,
    required String origin,
    required String description,
    required String background,
    required String difficulty,
    required int prepTime,
    required int cookTime,
    required List<Map<String, String>> ingredients,
    required List<String> instructions,
  }) async {
    submitting.value = true;
    try {
      final uri = Uri.parse('${ApiEndpoints.baseUrl}recipe/create');
      final token = await LocalStorageService().getToken();
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      final Map<String, dynamic> payload = {
        "recipeName": title,
        "estimateTime": "${prepTime + cookTime} minutes",
        "difficultyLevel": difficulty,
        "origin": origin,
        "description": description,
        "ingredients": ingredients
            .map((e) => '${e['quantity']} ${e['name']}')
            .join(', '),
        "instruction": instructions.join(', '),
        "cultureBackground": background,
      };

      request.fields['data'] = jsonEncode(payload);

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', imageFile!.path),
        );
      }

      if (musicFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('music', musicFile!.path),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        Get.back();
        showCustomSnackbar('Success', 'Recipe created successfully');
      } else {
        print("Error response: ${response.body}");
        showCustomSnackbar('Failed', 'Recipe creation failed');
      }
      log(response.body);
    } catch (e) {
      showCustomSnackbar('Error', e.toString());
    } finally {
      submitting.value = false;
    }
  }
}
