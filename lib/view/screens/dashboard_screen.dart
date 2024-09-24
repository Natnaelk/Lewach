import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lewach/controller/dashboard_controller.dart';
import 'package:lewach/helper/colors.dart';
import 'package:lewach/view/screens/account_screen.dart';
import 'package:lewach/view/screens/bid_history_screen.dart';
import 'package:lewach/view/screens/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;

  const DashboardScreen({super.key, this.pageIndex = 0});
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    BidHistoryScreen(),
    const AccountScreen()
  ];

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    // Get.find<LocationController>().getLocation();
    //  isUserSignin();

    // TODO: implement initState
    super.initState();
  }

  // Future<bool> isUserSignin() async {
  //   return await Get.find<AuthController>().isPhoneRegistered();
  // }

  @override
  Widget build(BuildContext context) {
    bool canExit = false;
    final dashboardController = Get.put(DashboardController());
    return WillPopScope(
      onWillPop: () async {
        if (canExit) {
          SystemNavigator.pop();
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Press back again to exit'.tr,
                style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: MyColors.primary,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(3),
          ));
          canExit = true;
          Timer(const Duration(seconds: 2), () {
            canExit = false;
          });
          return false;
        }
      },
      child: Scaffold(
        body: Obx(
          () =>
              DashboardScreen
                  ._widgetOptions[dashboardController.selectedIndex.value] ??
              const CircularProgressIndicator(),
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            elevation: 0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.currency_exchange),
                label: 'Bid History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts),
                label: 'Account',
              ),
            ],
            selectedItemColor: MyColors.primary,
            selectedIconTheme: IconThemeData(color: MyColors.primary),
            currentIndex: dashboardController.selectedIndex.value,
            onTap: (index) {
              dashboardController.changeIndex(index);
            },
          ),
        ),
      ),
    );
  }
}
