import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lewach/controller/bid_controller.dart';
import 'package:lewach/controller/user_controller.dart';

class BidDetailWidget extends StatelessWidget {
  final Map<String, dynamic> bidData; // Pass in the bid data

  const BidDetailWidget({Key? key, required this.bidData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BidController bidController = Get.put(BidController());
    UserController userController = Get.put(UserController());

    // Extract necessary data from bidData
    final bidReceiverItem = bidData['bidReceiversItem'];
    final bidSubmittersItem = bidData['bidSubmittersItem'];
    final RxString bidStatus =
        bidData['bidStatus'].toString().obs; // Reactive bid status
    final bidTime = bidData['bidTime'];
    final bidderName = bidData['bidderName'];
    final bidderPhone = bidData['bidderPhone'];
    final bidOption = bidData['bidOption'];
    final bidAmount = bidData['bidAmount'];

    // Separate loading states for Accept and Reject buttons
    final RxBool isAccepting = false.obs;
    final RxBool isRejecting = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bid Details'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Bidder's Item
            buildSectionTitle('Submitted Item', Icons.shopping_bag),
            SizedBox(height: 20),
            buildItemDetail(
              bidSubmittersItem['imageUrl'],
              bidSubmittersItem['productName'],
              bidSubmittersItem['price'],
              bidSubmittersItem['status'],
            ),
            SizedBox(height: 24),

            // Section 2: Receiver's Item
            buildSectionTitle('Bid Receiver\'s Item', Icons.shopping_cart),
            SizedBox(height: 20),
            buildItemDetail(
              bidReceiverItem['imageUrl'],
              bidReceiverItem['productName'],
              bidReceiverItem['price'],
              bidReceiverItem['status'],
            ),
            SizedBox(height: 24),

            // Section 3: Bid Option Details
            buildSectionTitle('Bid Option', Icons.attach_money),
            if (bidOption == "money") ...[
              buildInfoRow('Option', 'Money'),
              buildInfoRow('Amount', '\$$bidAmount'),
            ] else if (bidOption == "item") ...[
              buildInfoRow('Option', 'Item'),
            ] else if (bidOption == "both") ...[
              buildInfoRow('Option', 'Both'),
              buildInfoRow('Amount', '\$$bidAmount'),
              buildInfoRow('Item Offered', bidSubmittersItem['productName']),
            ],
            SizedBox(height: 20),

            // Section 4: Bid Status & Time
            buildSectionTitle('Bid Info', Icons.info_outline),
            Obx(() {
              return buildInfoRow('Status', bidStatus.value);
            }),
            buildInfoRow('Time', bidTime.toDate().toString()),
            SizedBox(height: 20),

            // Section 5: Show Bidder Info (Only if the bid is accepted and the viewer is the bid receiver)
            Obx(() {
              if (bidStatus.value == "accepted" &&
                  userController.userPhone.value ==
                      bidReceiverItem['creatorPhone']) {
                return Column(
                  children: [
                    buildInfoRow('Bidder Name', bidderName),
                    buildInfoRow('Bidder Phone', bidderPhone),
                  ],
                );
              } else {
                return SizedBox();
              }
            }),
            SizedBox(height: 24),

            // Section 6: Accept/Reject Buttons
            Obx(() {
              if (bidderPhone != userController.userPhone.value &&
                  bidStatus.value == "submitted") {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Accept Bid Button
                    isAccepting.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              isAccepting.value = true;
                              await bidController.acceptBid(bidData["bidId"]);
                              isAccepting.value = false;
                              // Update the status to accepted after successful bid acceptance
                              bidStatus.value = 'accepted';
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Accept Bid',
                                style: TextStyle(fontSize: 16)),
                          ),

                    // Reject Bid Button
                    isRejecting.value
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              isRejecting.value = true;
                              await bidController.rejectBid(bidData["bidId"]);
                              isRejecting.value = false;
                              // Update the status to rejected after successful bid rejection
                              bidStatus.value = 'rejected';
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Reject Bid',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red)),
                          ),
                  ],
                );
              } else {
                return SizedBox(); // Hide buttons when the bid is no longer "submitted"
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildItemDetail(
      String imageUrl, String productName, double price, String status) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Name: $productName', style: TextStyle(fontSize: 16)),
            Text('Price: \$$price', style: TextStyle(fontSize: 16)),
            Text('Status: $status', style: TextStyle(fontSize: 16)),
          ],
        )
      ],
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
