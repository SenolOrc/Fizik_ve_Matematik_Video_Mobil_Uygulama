
import 'package:cloud_firestore/cloud_firestore.dart';

enum FirebaseColletions {
  users,
  bookings,
  ratings,
  location;

  CollectionReference get reference =>
      FirebaseFirestore.instance.collection(name);
}
