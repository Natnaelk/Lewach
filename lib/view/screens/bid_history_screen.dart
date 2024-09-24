import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lewach/helper/date.dart';
import 'package:lewach/view/screens/bid_details_screen.dart';

import '../../controller/bid_controller.dart';

class BidHistoryScreen extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Submitted and Received
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bid History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Submitted Bids'),
              Tab(text: 'Received Bids'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SubmittedBids(),
            ReceivedTab(),
          ],
        ),
      ),
    );
  }
}

// class SubmittedBidsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Replace with your submitted bids data
//     return ListView.builder(
//       itemCount: 10, // Replace with your actual data count
//       itemBuilder: (context, index) {
//         return Card(
//           elevation: 4,
//           margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.blueAccent,
//               child: Text('S'), // Placeholder for submitter's initial
//             ),
//             title: Text('Bid Item ${index + 1}'), // Placeholder
//             subtitle: Text('Submitted on: Date'), // Replace with actual date
//             trailing: Icon(Icons.arrow_forward),
//             onTap: () {
//               // Navigate to bid detail screen
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class ReceivedBidsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Replace with your received bids data
//     return ListView.builder(
//       itemCount: 10, // Replace with your actual data count
//       itemBuilder: (context, index) {
//         return Card(
//           elevation: 4,
//           margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.greenAccent,
//               child: Text('R'), // Placeholder for receiver's initial
//             ),
//             title: Text('Received Item ${index + 1}'), // Placeholder
//             subtitle: Text('Received on: Date'), // Replace with actual date
//             trailing: Icon(Icons.arrow_forward),
//             onTap: () {
//               // Navigate to bid detail screen
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// Tab 1: Submitted Bids
class SubmittedBids extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bids')
          .where('bidderId',
              isEqualTo: currentUserId) // Bids made by current user
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var bids = snapshot.data!.docs;

        if (bids.isEmpty) {
          return Center(child: Text("You haven't placed any bids."));
        }

        return ListView.builder(
          itemCount: bids.length,
          itemBuilder: (context, index) {
            var bid = bids[index];
            Map<String, dynamic>? bidData = bid.data() as Map<String, dynamic>?;
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text('R'), // Placeholder for receiver's initial
                ),
                title: Text('Submitted Item ${index + 1}'), // Placeholder
                subtitle: Text(
                    'Submitted on: ${convertTimestampToReadableFormat(bid["bidTime"])}'), // Replace with actual date
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Get.to(BidDetailWidget(bidData: bidData!));
                  // Navigate to bid detail screen
                },
              ),
            );
          },
        );
      },
    );
  }
}

class ReceivedTab extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bids')
          .where('creatorId',
              isEqualTo: currentUserId) // Bids made by current user
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var bids = snapshot.data!.docs;

        if (bids.isEmpty) {
          return Center(child: Text("You haven't received any bids."));
        }

        return ListView.builder(
          itemCount: bids.length,
          itemBuilder: (context, index) {
            var bid = bids[index];
            Map<String, dynamic>? bidData = bid.data() as Map<String, dynamic>?;

            if (bidData == null) {
              return Center(child: Text("Error retrieving bid data."));
            }
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  child: Text('R'), // Placeholder for receiver's initial
                ),
                title: Text(
                    'You have received a bid for item ${bid["bidReceiversItem"]["productName"]}'), // Placeholder
                subtitle: Text(
                    'Received on: ${convertTimestampToReadableFormat(bid["bidTime"])}'), // Replace with actual date
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Get.to(BidDetailWidget(bidData: bidData));
                  // Navigate to bid detail screen
                },
              ),
            );
          },
        );
      },
    );
  }
}

// // Tab 2: Received Bids
// class ReceivedBids extends StatelessWidget {
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
//   final bidController = Get.put(BidController());

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('bids')
//           .where('creatorId',
//               isEqualTo: currentUserId) // Bids received for user's products
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         var bids = snapshot.data!.docs;

//         if (bids.isEmpty) {
//           return const Center(child: Text("You haven't received any bids."));
//         }

//         return ListView.builder(
//           itemCount: bids.length,
//           padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
//           itemBuilder: (context, index) {
//             var bid = bids[index];
//             String bidId = bid.id;
//             String bidStatus = bid['bidStatus']; // Retrieve current bid status

//             return ListTile(
//               title: Text("${bid['bidderName']} bid on your product: }"),
//               subtitle: Text("Bid amount: \$${bid['bidAmount']}"),
//               trailing: bidStatus == 'pending'
//                   ? Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             bidController.acceptBid(bidId);
//                           },
//                           child: const Text('Accept',
//                               style: TextStyle(color: Colors.green)),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             bidController.rejectBid(bidId);
//                           },
//                           child: const Text('Reject',
//                               style: TextStyle(color: Colors.red)),
//                         ),
//                       ],
//                     )
//                   : Text(
//                       bidStatus == 'accepted' ? "Accepted" : "Rejected",
//                       style: TextStyle(
//                           color: bidStatus == 'accepted'
//                               ? Colors.green
//                               : Colors.red,
//                           fontSize: 16),
//                     ), // Show bid status once accepted or rejected
//             );
//           },
//         );
//       },
//     );
//   }
// }
