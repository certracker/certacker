import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<void> deleteUserAccount(String userId) async {
  try {
    await FirebaseAuth.instance.currentUser?.delete();
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  } catch (error) {
    if (kDebugMode) {
      print('Error deleting user account: $error');
    }
  }
}
