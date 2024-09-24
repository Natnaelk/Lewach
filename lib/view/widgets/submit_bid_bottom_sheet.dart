import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lewach/controller/bid_controller.dart';

import '../../model/product_model.dart';
import 'common_button.dart';

void showBidBottomSheet(BuildContext context, Product bidReceiversItem) {
  final bidController = Get.put(BidController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Submit Your Bid',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Dropdown for selecting 'money' or 'item' as the bid option
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButtonFormField(
                    value: bidController.bidOption.value,
                    items: bidController.bidOptions.map((bidOption) {
                      return DropdownMenuItem(
                        value: bidOption,
                        child: Text(bidOption),
                      );
                    }).toList(),
                    onChanged: (value) {
                      bidController.bidOption.value = value!;
                      print(bidController.bidOption.value);
                    },
                    decoration: const InputDecoration(
                        labelText: 'Bid Options', border: InputBorder.none),
                  ),
                )),
            const SizedBox(height: 15),

            // Show money input if 'money' is selected
            Obx(() => bidController.bidOption.value == 'money' ||
                    bidController.bidOption == 'both'
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          controller: bidController.bidAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Bid Amount',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(height: 20)),

            // Show item details if 'item' is selected'
            SizedBox(
              height: 10,
            ),
            Obx(() => bidController.bidOption.value == 'item' ||
                    bidController.bidOption == 'both'
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: bidController.productNameController,
                          decoration:
                              const InputDecoration(labelText: 'Product Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a product name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            controller: bidController.priceEstimationController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText:
                                  'Price estimation of your product (Optional)',
                            ),
                          )),
                      SizedBox(height: 20),
                      bidController.bidOption.value == 'item' ||
                              bidController.bidOption == 'both'
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: DropdownButtonFormField(
                                value:
                                    bidReceiversItem.eligibleExchangeItems[0],
                                items: bidReceiversItem.eligibleExchangeItems
                                    .map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  bidController.submittedItemCategory.value =
                                      value!;
                                  print(bidController
                                      .submittedItemCategory.value);
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Category of your item',
                                    border: InputBorder.none),
                              ),
                            )
                          : SizedBox(),
                      const SizedBox(height: 15),
                      // Dropdown for item status
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Obx(() => DropdownButtonFormField(
                              value: bidController.status.value,
                              items: bidController.statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                bidController.status.value = value!;
                                print(bidController.status.value);
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Status of the Item'),
                            )),
                      ),

                      const SizedBox(height: 20),
                    ],
                  )
                : const SizedBox()),
            bidController.bidOption.value == 'money'
                ? SizedBox()
                : Obx(() => bidController.selectedImage.value == null
                    ? const Text("No image selected")
                    : Image.file(bidController.selectedImage.value!,
                        height: 100)),
            bidController.bidOption.value == 'money'
                ? SizedBox()
                : ElevatedButton(
                    onPressed: bidController.pickImage,
                    child: const Text('Pick Image'),
                  ),
            const SizedBox(height: 40),
            Obx(() {
              return bidController.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : CommonButton(
                      onPressed: () {
                        bidController.submitBid(
                            bidReceiversItem); // Call the add item method
                      },
                      child: Text(
                        'Submit bid',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
            }),
            // Submit button
            // ElevatedButton(
            //   onPressed: () {
            //     bidController.submitBid(productId, productOwnerId, productName);
            //     Navigator.pop(
            //         context); // Close the bottom sheet after submission
            //   },
            //   child: const Text('Submit Bid'),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
