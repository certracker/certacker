import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUserDetails(String userId, Map<String, dynamic> userDetails) {
    return usersCollection.doc(userId).set(userDetails);
  }

  Future<Object?> getUserDetails(String userId) async {
    DocumentSnapshot<Object?> userSnapshot =
        await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      return userSnapshot.data();
    } else {
      return null;
    }
  }
}
