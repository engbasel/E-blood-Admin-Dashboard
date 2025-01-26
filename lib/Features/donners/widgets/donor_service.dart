// donor_service.dart

import 'package:adminbloodv2/FirestoreConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all donors
  Stream<QuerySnapshot> fetchDonors() {
    return _firestore
        .collection(FirestoreConstants.bloodRequestsCollection)
        .snapshots();
  }

  // Update a donor
  Future<void> updateDonor(
      String docId, Map<String, dynamic> updatedData) async {
    await _firestore
        .collection(FirestoreConstants.donorRequestsCollection)
        .doc(docId)
        .update(updatedData);
  }

  // Delete a donor
  Future<void> deleteDonor(String docId) async {
    await _firestore
        .collection(FirestoreConstants.donorRequestsCollection)
        .doc(docId)
        .delete();
  }
}

class DonorFields {
  static const String name = 'name';
  static const String address = 'address';
  static const String contact = 'contact';
  static const String bloodType = 'bloodType';
  static const String hospitalName = 'hospitalName';
  static const String lastRequestDate = 'lastRequestDate';
}
