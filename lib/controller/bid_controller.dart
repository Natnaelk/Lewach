import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lewach/controller/user_controller.dart';
import 'package:path/path.dart' as path;

import '../model/product_model.dart';

class BidController extends GetxController {
  final bidAmountController = TextEditingController();
  final productNameController = TextEditingController();
  final priceEstimationController = TextEditingController();

  final userController = Get.put(UserController());
  Rxn<File> selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();
  RxBool isLoading = false.obs;
  RxString bidOption = 'money'.obs;
  RxString submittedItemCategory = ''.obs;
  final List<String> bidOptions = ['money', 'item', 'both'];

  RxString status = 'New'.obs;
  final List<String> statusOptions = ['New', 'Slightly Used', 'Used'];

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

  // Form validation metho

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

  bool validateForm() {
    if (bidOption.value == 'money' && bidAmountController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in bid amount field.");
      return false;
    } else if (bidOption.value == 'item') {
      if (productNameController.text.isEmpty ||
          priceEstimationController.text.isEmpty ||
          selectedImage.value == null) {
        Get.snackbar("Error", "Please fill in all fields and add an image.");
        return false;
      }
    } else if (bidOption.value == 'both') {
      if (productNameController.text.isEmpty ||
          priceEstimationController.text.isEmpty ||
          selectedImage.value == null ||
          bidAmountController.text.isEmpty) {
        Get.snackbar("Error", "Please fill in all fields and add an image.");
        return false;
      }
    }

    return true;
  }

  // Function to submit a bid
  Future<void> submitBid(Product bidReceiversItem) async {
    late String imageUrl;
    String userId;
    String userEmail;
    late double bidAmount;
    late BidSubmittersProduct bidSubmittersProduct;

    if (!validateForm()) return;
    isLoading.value = true;

    try {
      if (bidOption == "item") {
        imageUrl = await uploadImageToStorage(selectedImage.value!);

        bidSubmittersProduct = BidSubmittersProduct(
            productName: productNameController.text.trim(),
            price: double.parse(priceEstimationController.text.trim()),
            status: status.value,
            imageUrl: imageUrl);
      } else if (bidOption == "both") {
        imageUrl = await uploadImageToStorage(selectedImage.value!);

        bidSubmittersProduct = BidSubmittersProduct(
            productName: productNameController.text.trim(),
            price: double.parse(priceEstimationController.text.trim()),
            status: status.value,
            imageUrl: imageUrl);
        bidAmount = double.parse(bidAmountController.text.trim());
      } else {
        bidAmount = double.parse(bidAmountController.text.trim());
      }

      userId = FirebaseAuth.instance.currentUser!.uid;
      userEmail = FirebaseAuth.instance.currentUser!.email ?? '';

      // Timestamp of bid submission
      Timestamp bidTime = Timestamp.now();

      // Create a reference to a new document in the 'bids' collection to generate a unique ID
      DocumentReference newBidRef =
          FirebaseFirestore.instance.collection('bids').doc();
      String bidId = newBidRef.id; // Get the unique bid ID

      // Create bid data for both "Received Bids" (for product owner) and "Submitted Bids" (for the bidder)
      Map<String, dynamic> bidData = {
        'bidderId': userId,
        'bidderName': userController.userName.value,
        'bidderEmail': userEmail,
        'bidderPhone': userController.userPhone.value,
        'bidReceiversItem': bidReceiversItem.toFirestore(),
        'bidOption': bidOption.value,
        'bidTime': bidTime,
        'bidStatus': 'submitted',
        'creatorId': bidReceiversItem.creatorId,
        'bidId': bidId, // Add the bid ID to the bid data
      };

      if (bidOption.value == 'money') {
        // Include bid amount for money bid
        bidData['bidAmount'] = bidAmount;
      } else if (bidOption.value == 'item') {
        // Include the submitter's item details for item bid
        bidData['bidSubmittersItem'] = bidSubmittersProduct.toFirestore();
      } else if (bidOption.value == 'both') {
        bidData['bidAmount'] = bidAmount;
        bidData['bidSubmittersItem'] = bidSubmittersProduct.toFirestore();
      }

      // Use the reference to set the bid data
      await newBidRef
          .set(bidData); // This adds the document with the generated bid ID
      Get.back();
      Get.snackbar('Success', 'Bid submitted successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', 'Failed to submit bid: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch bids for a product (to be shown to the product creator)
  Stream<List<Map<String, dynamic>>> getProductBids(String productId) {
    return FirebaseFirestore.instance
        .collection('items')
        .doc(productId)
        .collection('bids')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Fetch the bid history for the user (to be shown to the bid submitter)
  Stream<List<Map<String, dynamic>>> getUserBidHistory() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bidHistory')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> acceptBid(String bidId) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance.collection('bids').doc(bidId).update({
        'bidStatus': 'accepted',
      });

      // Optionally: Notify the bidder that their bid has been accepted
    } catch (e) {
      print("Error accepting bid: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Function to reject a bid
  Future<void> rejectBid(String bidId) async {
    isLoading.value = true;
    try {
      await FirebaseFirestore.instance.collection('bids').doc(bidId).update({
        'bidStatus': 'rejected',
      });

      // Optionally: Notify the bidder that their bid has been rejected
    } catch (e) {
      print("Error rejecting bid: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
