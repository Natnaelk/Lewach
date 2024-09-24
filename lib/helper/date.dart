import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String convertTimestampToReadableFormat(Timestamp timestamp) {
  // Convert the Firestore Timestamp to DateTime
  DateTime dateTime = timestamp.toDate();

  // Format the DateTime to a more readable format
  String formattedDate = DateFormat('MMMM d, yyyy h:mm a').format(dateTime);

  return formattedDate;
}
