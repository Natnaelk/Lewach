import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lewach/view/screens/add_item_screen.dart';
import 'package:lewach/view/widgets/bid_card_widget.dart';

import '../../helper/colors.dart';
import '../../model/product_model.dart';
import '../widgets/submit_bid_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Ensures circular shape
        ),
        onPressed: () {
          Get.to(AddItemScreen());
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 50),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hi, Welcome to Lewach',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Search Field
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Search',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Body Content (Wrapped with Expanded to manage scrolling)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trending Items
                    Text(
                      'Trending Items for bid',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('items')
                            .where('creatorId',
                                isNotEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: MyColors.primary,
                              ),
                            );
                          }

                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            List<Product> products = snapshot.data!.docs
                                .map((DocumentSnapshot document) =>
                                    Product.fromFirestore(document))
                                .toList();

                            return SizedBox(
                              height:
                                  280, // Adjust height for horizontal scroll
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return BidCardWidget(
                                    submitBid: () {
                                      showBidBottomSheet(
                                          context, products[index]);
                                    },
                                    price: products[index].price,
                                    title: products[index].productName,
                                    color: Colors.green.withOpacity(0.3),
                                    imagePath: products[index].imageUrl,
                                    numberOfBids: 10,
                                    percentFinished: 10,
                                    //  quantity: products[index].quantity,
                                    self: false,
                                    status: products[index].status,
                                    eligibleItems:
                                        products[index].eligibleExchangeItems,
                                    creatorId: products[index].creatorId,
                                  );
                                },
                              ),
                            );
                          }

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "No products found",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 20),
                    // All Items for bid
                    Text(
                      'All items for bid',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('items')
                            .where('creatorId',
                                isNotEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: MyColors.primary,
                              ),
                            );
                          }

                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            List<Product> products = snapshot.data!.docs
                                .map((DocumentSnapshot document) =>
                                    Product.fromFirestore(document))
                                .toList();

                            return SizedBox(
                              height:
                                  280, // Adjust height for horizontal scroll
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return BidCardWidget(
                                    submitBid: () {
                                      showBidBottomSheet(
                                          context, products[index]);
                                    },
                                    price: products[index].price,
                                    title: products[index].productName,
                                    color: Colors.green.withOpacity(0.3),
                                    imagePath: products[index].imageUrl,
                                    numberOfBids: 10,
                                    percentFinished: 10,
                                    //  quantity: products[index].quantity,
                                    self: false,
                                    status: products[index].status,
                                    eligibleItems:
                                        products[index].eligibleExchangeItems,
                                    creatorId: products[index].creatorId,
                                  );
                                },
                              ),
                            );
                          }

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "No products found",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 30),
                    // My Items
                    Text(
                      'My items',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('items')
                            .where('creatorId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: MyColors.primary,
                              ),
                            );
                          }

                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            List<Product> products = snapshot.data!.docs
                                .map((DocumentSnapshot document) =>
                                    Product.fromFirestore(document))
                                .toList();

                            return SizedBox(
                              height:
                                  250, // Adjust height for horizontal scroll
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return BidCardWidget(
                                    submitBid: () {},
                                    price: products[index].price,
                                    title: products[index].productName,
                                    color: Colors.green.withOpacity(0.3),
                                    imagePath: products[index].imageUrl,
                                    numberOfBids: 10,
                                    percentFinished: 10,
                                    //  quantity: products[index].quantity,
                                    self: true,
                                    status: products[index].status,
                                    eligibleItems:
                                        products[index].eligibleExchangeItems,
                                    creatorId: products[index].creatorId,
                                  );
                                },
                              ),
                            );
                          }

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "You haven't added any product yet",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
