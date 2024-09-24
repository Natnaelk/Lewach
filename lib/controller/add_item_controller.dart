import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../model/product_model.dart';
import 'user_controller.dart';

class AddItemController extends GetxController {
  // Text Controllers for the form fields
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final maxBidsController = TextEditingController();
  final statusController = TextEditingController();
  final imageUrlController = TextEditingController();
  UserController userController = Get.find<UserController>();
  List<String> exchangeItemList = [
    'car',
    'book',
    'tv',
    'bed',
    'shoe',
    'tshirt',
    'sofa'
  ];
  RxList<String> eligibleExchangeItems = <String>[].obs;

  // Status of the item
  RxString status = 'New'.obs;
  final List<String> statusOptions = ['New', 'Slightly Used', 'Used'];

  RxString bidOption = 'money'.obs;
  final List<String> bidOptions = ['money', 'item', 'both'];

  // Image handling
  Rxn<File> selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  // Loading state
  RxBool isLoading = false.obs;

  void addEligibleExchangeItem(String item) {
    if (item.isNotEmpty && !eligibleExchangeItems.contains(item)) {
      eligibleExchangeItems.add(item);
    } else {
      Get.snackbar("Error", "Item already added or empty.");
    }
  }

  // Method to pick an image
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      } else {
        Get.snackbar("No Image", "Please select an image.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  // Form validation method
  bool validateForm() {
    if (productNameController.text.isEmpty ||
        priceController.text.isEmpty ||
        maxBidsController.text.isEmpty ||
        selectedImage.value == null) {
      Get.snackbar("Error", "Please fill in all fields and add an image.");
      return false;
    }
    return true;
  }

  // Method to upload image to Firebase Storage and get the download URL
  Future<String> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('item_images').child(fileName);

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  // Method to add item to Firestore
  Future<void> addItem() async {
    if (!validateForm()) return;

    // Start loading
    isLoading.value = true;

    try {
      // Upload image to Firebase Storage and get download URL
      String imageUrl = await uploadImageToStorage(selectedImage.value!);

      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference newProductRef = firestore.collection('items').doc();

      // Create a Product object
      Product newProduct = Product(
        id: newProductRef.id,
        productName: productNameController.text.trim(),
        price: priceController.text.isEmpty
            ? 0
            : double.parse(priceController.text
                .trim()), // You can adjust this logic if price is needed
        status: status.value,
        imageUrl: imageUrl, // You can handle image uploading separately
        creatorId: FirebaseAuth.instance.currentUser!.uid,
        creatorName: userController.userName.value,
        creatorPhone: userController.userPhone.value,
        createdAt: Timestamp.now(),

        eligibleExchangeItems: eligibleExchangeItems.toList(),
      );

      // Save the product to Firestore
      await newProductRef.set(newProduct.toFirestore());

      Get.back();
      Get.snackbar('Success', 'Product added successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      print(e.toString());
    } finally {
      // Stop loading
      isLoading.value = false;
    }
  }
}
