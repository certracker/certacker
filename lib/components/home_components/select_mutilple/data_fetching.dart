import 'package:certracker/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchUserData() async {
  try {
    String? userId = AuthenticationService().getCurrentUserId();

    if (userId != null) {
      List<QuerySnapshot> snapshots = await Future.wait([
        FirebaseFirestore.instance
            .collection('Certification')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('License')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('Education')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('Vaccination')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('Travel')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('CEU')
            .where('userId', isEqualTo: userId)
            .get(),
        FirebaseFirestore.instance
            .collection('Others')
            .where('userId', isEqualTo: userId)
            .get(),
      ]);
      List<Map<String, dynamic>> userData = [];
      for (QuerySnapshot snapshot in snapshots) {
        userData.addAll(
          snapshot.docs.map((doc) => {
            ...doc.data() as Map<String, dynamic>,
            'tableName': doc.reference.parent.id,
            'timestamp': doc['timestamp'],
          }),
        );
      }
      return userData;
    } else {
      throw Exception('User not authenticated!');
    }
  } catch (e) {
    print('Error fetching user data: $e');
    rethrow;
  }
}
