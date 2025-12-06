import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_recipes_afame/services/local_storage_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_recipes_afame/utils/ApiEndpoints.dart';
import 'package:food_recipes_afame/models/profile/profile_update_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  var isLoading = false.obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      Get.snackbar(
         'Validation Error',
         'All fields are required',
      );
      return;
    }
    if (phone.length < 10 || phone.length > 15) {
      Get.snackbar(
         'Validation Error',
        
            'Phone number must be at least 10 digits and at most 15 digits',
      );
      return;
    }

    isLoading.value = true;

    try {
      final uri = Uri.parse(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.updateProfile}",
      );
      var request = http.MultipartRequest('PATCH', uri);

      request.fields['name'] = name;
      request.fields['phone'] = phone;

      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImage',
            selectedImage.value!.path,
          ),
        );
      }
      final token = await LocalStorageService().getToken();

      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();
      final parsedResponse = await http.Response.fromStream(response);
      final responseData = jsonDecode(parsedResponse.body);

      if (response.statusCode == 200) {
        final updatedProfile = ProfileUpdatedResponseModel.fromJson(
          responseData,
        );
        Get.back();
        Get.snackbar(
           "Success",
           updatedProfile.message,
          backgroundColor: Colors.green,
        );
      } else {
        throw responseData['message'] ?? 'Update failed';
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar( "Error",  e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
