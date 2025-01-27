// donor_service.dart

import 'package:adminbloodv2/FirestoreConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all donors
  Stream<QuerySnapshot> fetchDonors() {
    return _firestore
        .collection(FirestoreConstants.donorRequestsCollection)
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
  // Personal Information
  static const String name = 'name';
  static const String age = 'age';
  static const String gender = 'gender';
  static const String bloodType = 'bloodType';
  static const String address = 'address';
  static const String city = 'city';
  static const String contact = 'contact';
  static const String idCard = 'idCard';
  static const String uId = 'uId';

  // Medical Information
  static const String medicalConditions = 'medicalConditions';
  static const String allergyDetails = 'allergyDetails';
  static const String height = 'height';
  static const String weight = 'weight';
  static const String units = 'units';

  // Donation Information
  static const String donationType = 'donationType';
  static const String lastDonationDate = 'lastDonationDate';
  static const String lastRequestDate = 'lastRequestDate';
  static const String nextDonationDate = 'nextDonationDate';

  // Hospital Information
  static const String hospitalName = 'hospitalName';

  // Additional Information
  static const String notes = 'notes';
  static const String distance = 'distance';
}
