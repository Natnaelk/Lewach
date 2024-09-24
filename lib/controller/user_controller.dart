import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var currentUser = Rxn<User>();
  var userName = ''.obs;
  var userPhone = ''.obs;
  var userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData(); // Fetch user data when the controller is initialized
  }

  // Function to get current user data
  void getUserData() async {
    // Get the current logged-in user
    currentUser.value = FirebaseAuth.instance.currentUser;

    if (currentUser.value != null) {
      // Set the email from FirebaseAuth
      userEmail.value = currentUser.value!.email ?? 'No email';

      // Fetch additional user details from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.value!.uid)
          .get();

      if (userDoc.exists) {
        userName.value = userDoc['full_name'] ?? 'No name';
        userPhone.value = userDoc['phone_number'] ?? 'No phone';
      }
    }
  }

  // Logout function
  void logout() async {
    await FirebaseAuth.instance.signOut();
    currentUser.value = null;
    userName.value = '';
    userPhone.value = '';
    userEmail.value = '';
  }
}
