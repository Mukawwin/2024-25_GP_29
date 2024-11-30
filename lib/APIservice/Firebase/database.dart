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
        // for (var allergy in snapshot.docs) {
        //   await _firestore.collection("allergies").doc(allergy.id).get().;
        // }
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
  Future<void> addUserAllergy(String allergyId) async {
    try {
      await _firestore
          .collection('user_allergies')
          .add({"allergy_id": allergyId, "user_uid": _auth.currentUser!.uid});
      print('Allergy added successfully!');
    } catch (e) {
      print('Error adding allergy: $e');
      rethrow;
    }
  }

  Future<AllergyModel?> getAllergyFromID(String id) async {
    print("UOD; ${_auth.currentUser!.uid}");
    QuerySnapshot snapshot = await _firestore
        .collection('user_allergies')
        .where("user_uid", isEqualTo: _auth.currentUser!.uid)
        .where("allergy_id", isEqualTo: id)
        .get();
    if (snapshot.docs.isNotEmpty) {
      print("yyyye");
      return AllergyModel.fromFirestore(
          snapshot.docs.first.data() as Map<String, dynamic>,
          snapshot.docs.first.id);
    } else {
      return null;
    }
  }

  // Delete an allergy using the document ID
  Future<void> deleteUserAllergy(String docId) async {
    try {
      await _firestore
          .collection('user_allergies')
          .where("user_uid", isEqualTo: _auth.currentUser!.uid)
          .where("allergy_id", isEqualTo: docId)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await _firestore
              .collection('user_allergies')
              .doc(value.docs.first.id)
              .delete();
          return;
        }
      });
      print('Allergy deleted successfully!');
    } catch (e) {
      print('Error deleting allergy: $e');
      rethrow;
    }
  }

  Future<List<AllergyModel>> getAllergies() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('allergies').get();
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((doc) => AllergyModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching user allergies: $e');
      rethrow;
    }
  }

  Future<bool> checkIfAllergyExsit(String id) async {
    // try {
    // print(_auth.currentUser!.uid);
    // print(id);
    var data = await _firestore
        .collection('user_allergies')
        .where("user_uid", isEqualTo: _auth.currentUser!.uid)
        .where("allergy_id", isEqualTo: id)
        .get();

    if (data.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
 
  }

  Future<List<AllergyModel>> getUserAllergiesTitle() async {
    try {
      List<AllergyModel> userAllergies = [];

      // Fetch user allergies
      QuerySnapshot userAllergiesSnapshot = await _firestore
          .collection('user_allergies')
          .where('user_uid', isEqualTo: _auth.currentUser!.uid)
          .get();

      // Get IDs from the snapshot
      List<String> allergyIds = userAllergiesSnapshot.docs
          .map((doc) =>
              (doc.data() as Map<String, dynamic>)['allergy_id'].toString())
          .toList();

      if (allergyIds.isEmpty) {
        return [];
      }

      // Fetch all allergy data in one query
      QuerySnapshot allergySnapshot = await _firestore
          .collection('allergies')
          .where(FieldPath.documentId, whereIn: allergyIds)
          .get();

      // Map allergy data to models
      userAllergies = allergySnapshot.docs
          .map((doc) => AllergyModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      print(allergyIds.length);
      print(userAllergies.length);
      return userAllergies;
    } catch (e) {
      print('Error fetching user allergies: $e');
      return []; // Return an empty list on error instead of rethrowing
    }
  }
}
