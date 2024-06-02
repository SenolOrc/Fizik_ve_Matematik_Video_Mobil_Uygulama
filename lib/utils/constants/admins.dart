import 'package:firebase_auth/firebase_auth.dart';

class Admins {
  static const List<String> adminList = ['ke4vXB5HtfNejmIeVssGPC2pFDl1'];
  final bool isAdmin =
      adminList.contains(FirebaseAuth.instance.currentUser!.uid);
}
