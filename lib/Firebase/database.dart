import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all allergies for a specific user by user_uid
  Future<List<UserAllergy>> getUserAllergies() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('user_allergies')
          .where('user_uid', isEqualTo: _auth.currentUser!.uid)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((doc) => UserAllergy.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching user allergies: $e');
      rethrow;
    }
  }

  // Add a new allergy for a user
  Future<void> addUserAllergy(String allergy) async {
    try {
      await _firestore
          .collection('user_allergies')
          .add({"allergie": allergy, "user_uid": _auth.currentUser!.uid});
      print('Allergy added successfully!');
    } catch (e) {
      print('Error adding allergy: $e');
      rethrow;
    }
  }

  Future<UserAllergy?> getAllergyFromName(String allargy) async {
    print("UOD; ${_auth.currentUser!.uid}");
    QuerySnapshot snapshot = await _firestore
        .collection('user_allergies')
        .where("user_uid", isEqualTo: _auth.currentUser!.uid)
        .where("allergie", isEqualTo: allargy)
        .get();
    if (snapshot.docs.isNotEmpty) {
      print("yyyye");
      return UserAllergy.fromFirestore(
          snapshot.docs.first.data() as Map<String, dynamic>,
          snapshot.docs.first.id);
    } else {
      return null;
    }
  }

  // Delete an allergy using the document ID
  Future<void> deleteUserAllergy(String docId) async {
    try {
      await _firestore.collection('user_allergies').doc(docId).delete();
      print('Allergy deleted successfully!');
    } catch (e) {
      print('Error deleting allergy: $e');
      rethrow;
    }
  }
}
