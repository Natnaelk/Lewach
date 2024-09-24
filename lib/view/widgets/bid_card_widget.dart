import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';

class BidCardWidget extends StatelessWidget {
  final Color color;
  final String title;
  final int numberOfBids;
  final double percentFinished;
  final String imagePath;
  final double price;
  final VoidCallback submitBid;
  final bool self;
  final String status;
  final List<String> eligibleItems;
  final String creatorId;

  const BidCardWidget({
    super.key,
    required this.color,
    required this.title,
    required this.numberOfBids,
    required this.percentFinished,
    required this.imagePath,
    required this.price,
    required this.submitBid,
    required this.self,
    required this.status,
    required this.eligibleItems,
    required this.creatorId,
  });

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> hasSubmittedBidStream(
        String creatorId) {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      return FirebaseFirestore.instance
          .collection('bids')
          .where('bidderId', isEqualTo: userId)
          .where('creatorId', isEqualTo: creatorId)
          .snapshots();
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: hasSubmittedBidStream(creatorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Text('Loading...')),
            ],
          ); // Loading state
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          // Bid has been submitted
          return Container(
            margin: const EdgeInsets.only(right: 20, top: 10),
            padding: const EdgeInsets.all(10),
            width: 175,
            height: 550,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(status, style: const TextStyle(fontSize: 11)),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 5.0,
                  children: eligibleItems
                      .map((item) =>
                          Text('$item, ', style: const TextStyle(fontSize: 11)))
                      .toList(),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '$numberOfBids Bids',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 12),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 2, right: 2),
                      child: Text('|'),
                    ),
                    Text(
                      '$price Br',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 150,
                  height: 100,
                  child: Image.network(
                    imagePath,
                    width: 140,
                    height: 130,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                self
                    ? const SizedBox()
                    : Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Bid Submitted',
                              style: TextStyle(color: Colors.red[300])),
                        ),
                      ),
              ],
            ),
          );
        } else {
          // No bid submitted
          return Container(
            margin: const EdgeInsets.only(right: 20, top: 10),
            padding: const EdgeInsets.all(10),
            width: 175,
            height: 550,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(status, style: const TextStyle(fontSize: 11)),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 5.0,
                  children: eligibleItems
                      .map((item) =>
                          Text('$item, ', style: const TextStyle(fontSize: 11)))
                      .toList(),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '$numberOfBids Bids',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 12),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 2, right: 2),
                      child: Text('|'),
                    ),
                    Text(
                      '$price Br',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 150,
                  height: 100,
                  child: Image.network(
                    imagePath,
                    width: 140,
                    height: 130,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                self
                    ? const SizedBox()
                    : Center(
                        child: TextButton(
                          onPressed: submitBid,
                          child: const Text('Submit a bid'),
                        ),
                      ),
              ],
            ),
          );
        }
      },
    );
  }
}
