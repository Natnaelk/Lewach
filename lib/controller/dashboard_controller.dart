import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  bool isInCart = false;
  Rx<RangeValues> costRangeValues =
      Rx<RangeValues>(const RangeValues(0, 20000));

  RxBool isCartIconTaped = false.obs;
  RxBool isCouponbtnTaped = false.obs;

  RxInt groupValuAsc = 10.obs;
  RxBool isLoading = true.obs;
  var selectedIndex = 0.obs;

  // void checkInternetConnection2() async {
  //   if (await InternetConnectionChecker().hasConnection) {
  //     // showCustomSnackBar('connected to internet!', isError: false);
  //   } else {}
  // }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
